# noodle_timer_f

アラームの停止をスマホを持ち上げるだけで行えます

# DEMO

![カップラーメンの上のスマホタイマー](https://github.com/I10n/open-and-stop-timer/assets/89304633/e12801a1-8289-40d3-9429-2fc775fd4d24)


# Requirement

* flutter SDK
* Android Studio Iguana | 2023.2.1
* 動作テストデバイス POCO X3 (MIUI Global 13.0.3)

# Installation
flutterSDK, AndroidStudioが必要
## 1.flutter環境を用意する
Windowsの場合，
1. flutter SDKをインストール https://docs.flutter.dev/release/archive?tab=windows
2. インストール・解凍したディレクトリの`flutter/bin`にPathを通す
3. Pathが通っているか確認．
```bash
flutter doctor
```
4.`flutter doctor`の結果に従って，環境構築（Android Studioのインストールとか...）

## 2.プロジェクトを動かす

1. このリポジトリを複製
```bash
git clone https://github.com/I10n/open-and-stop-timer.git
```
2. Android Studioでプロジェクトを開く
3. Android Studioで[仮想端末を作り，アプリをRun](https://developer.android.com/codelabs/basic-android-kotlin-compose-emulator?hl=ja#2) or USBデバック有効にしたスマホをUSBでパソコンにつなぎ，アプリをRun

# Usage

1. カップラーメンにお湯を注ぐ
2. スマホで`noodle_timer_f`アプリを開いて，カップラーメンの上に乗せる（タイマーセット）
3. アラームが鳴ったら，タイマーを放り投げ（`Reset`ボタンを押さなくても止まる），蓋を破き捨てる
4. ラーメンを食べる

# Note

1. 持ち上げたらアラームが止まる機能は，アプリを開いた時のタイマーでのみ動作します
2. タイマー時間を変更したい場合は，時間変更=>`START`ボタン押す の一連の動作が必要

# License

"noodle_timer_f" is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).

使用した音素材：OtoLogic(https://otologic.jp)
