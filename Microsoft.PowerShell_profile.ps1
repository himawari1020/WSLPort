function WSL-Port {
    param (
        [Alias("o")]
        [Parameter(Mandatory=$false, HelpMessage="Open ports")]
        [switch]$open,

        [Alias("c")]
        [Parameter(Mandatory=$false, HelpMessage="Close ports")]
        [switch]$close,

        [Alias("l")]
        [Parameter(Mandatory=$false, HelpMessage="List current port mappings")]
        [switch]$list,

        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true)]
        [int[]]$Ports
    )

    if (-not $open -and -not $close -and -not $list) {
        echo "Either --open, --close, or --list must be specified."
        return
    }

    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
        Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs;
        exit
    }

    if ($list) {
        iex "netsh interface portproxy show v4tov4";
        return
    }

    $ip = bash.exe -c "ip r | tail -n1 | cut -d ' ' -f9"
    if (! $ip) {
        echo "The Script Exited, the IP address of WSL 2 cannot be found";
        exit;
    }

    if ($Ports.Length -eq 0) {
        echo "No ports specified. The Script Exited."
        exit;
    }

    $ports_a = $Ports -join ",";

    if ($open) {
        iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock'";

        iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
        iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

        foreach ($port in $Ports) {
            iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=* connectport=$port connectaddress=$ip";
        }

        iex "netsh interface portproxy show v4tov4";
    }
    
    if ($close) {
        foreach ($port in $Ports) {
            iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=*"
        }
    }
}

Set-Alias -Name "wslport" WSL-Port
