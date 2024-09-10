# WSLPort
WSL2のポート開放を行うps1スクリプト？エイリアス、gpt4で生成しました。
自身の環境ではDocuments配下においています。

# 想定環境
あらかじめWSL2が入っていること、このスクリプトはWSL2ありきの物です。
また、.wslconfigを下記の様にミラーモードで使っている人のみ限定です、NATモードでは動作未確認です。

```/mnt/c/Users/{USER}/.wslconfig
[wsl2]
networkingMode=mirrored
dnsTunneling=true
firewall=true
autoProxy=true
```

# 概要
このスクリプトはWSL2のポート開放を行うスクリプトです。**※IPv4にしか対応していません。**

#使い方

## ポート開放(oオプション)
oオプションでポート開放を行います、半角スペースで区切ってポートを複数指定が可能です。

```powershell
wslport -o 22 80 1234 ....
```

## ポートを閉じる(cオプション)
cオプションでポートを閉じます、oオプションと同様に複数指定が可能です。

```powershell
wslport -c 22 80 1234 ....
```

## ポートの確認(lオプション)
lオプションで開放中のポートを確認します。

```powershell
wslport -l
```
