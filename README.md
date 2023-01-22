
# OBS Youtube Live Stream Chat URL Updater

OBSでYoutube Live配信のチャットコメントを表示するブラウザソースのURLを自動更新するスクリプトです。

A script that automatically updates the URL of the browser source that displays Youtube Live stream chat comments in OBS.

---

## 目次 / Content(s)
* OBSへの導入方法 / How to install to OBS
* 設定 / Setting
* トラブルシューティング / Troubleshooting
* ライセンス / License

---

# OBSへの導入方法 / How to install to OBS
OBS メニューの[ツール(T)]→[スクリプト]を選びます。

Select [Tools (T)] → [Scripts] from the OBS menu.

![menu,tool,script](docs/img/020.png)

スクリプトウインドウが表示されます。 スクリプトタブの[+]を押してスクリプトファイルを追加します。

A script window will appear. Add a script file by pressing [+] on the script tab.

![script,add](docs/img/030.png)

youtube-live-stream-chat-updater.lua を開きます。

Open youtube-live-stream-chat-updater.lua

![script,add](docs/img/040.png)

導入が完了しました。

Installation completed.

![script,add](docs/img/050.png)

---

# 設定 / Setting

![script,add](docs/img/060.png)

設定の各項目は、一度入力すると値が保持されます。<br>
以降はOBSを起動すると自動でURLの更新が行われます。<br>
※ボタンを押して手動で更新することもできます。

Each setting item retains its value once entered.<br>
After that, when you start OBS, the URL will be updated automatically.<br>
*You can also update manually by pressing the button.

## Channel URL

Channel URL にはあなたのチャンネルのトップページURL、またはライブ タブのURLを設定してください。<br>
トップページURLの場合、チャンネルのカスタマイズによって正常に情報を取得できない場合があります。<br>
その場合は、ライブ タブのURLを設定してください。<br>
例1) https://www.youtube.com/@yuki_natsuno_vt<br>
例2) https://www.youtube.com/@yuki_natsuno_vt/streams

For Channel URL, set the URL of your channel's top page or the URL of the live stream tab.<br>
In the case of the top page URL, information may not be obtained properly due to channel customization.<br>
In that case, please set the URL of the live stream tab.<br>
Example 1) https://www.youtube.com/@yuki_natsuno_vt<br>
Example 2) https://www.youtube.com/@yuki_natsuno_vt/streams

## Source name

Source name には、チャットコメントのURLを設定する、ブラウザソースの名前を設定してください。<br>
名前に使用できる文字は半角英数のみです。全角文字（日本語や記号）を含む場合正常に動作しません。

For Source name, set the name of the browser source that sets the chat comment URL.<br>
Only alphanumeric characters can be used in the name.

![script,add](docs/img/010.png)

## Update LiveChat URL Button

ブラウザソースに設定されているチャットのURLを更新します。

Update the chat URL set in the browser source.

---

# トラブルシューティング / Troubleshooting

スクリプトウインドウの[スクリプトログ]ボタンを押すと、スクリプトログウインドウが表示されます。<br>
[youtube-live-stream-chat-url-updater.lua] Error: ~~~ が表示されている場合は次の内容を確認してください。

When you press the [Script Log] button in the script window, the script log window is displayed.<br>
If "[youtube-live-stream-chat-url-updater.lua] Error: ~~~" is displayed, check the following.
![script,add](docs/img/070.png)

## [youtube-live-stream-chat-url-updater.lua] Error: videoId was not found.

Channel URLに誤りがあるか、指定のURLからコンテンツの情報を取得できない状態になっています。

There is an error in the Channel URL, or content information cannot be obtained from the specified URL.

## [youtube-live-stream-chat-url-updater.lua] Error: curl command is not found.

URLからページ情報を取得する curl コマンドが見つかりませんでした。<br>
Windows10/Macには標準でインストールされているはずですが、インストールされていないようであれば新たにインストールしてください。

I couldn't find a curl command to get page information from a URL. <br>
It should be installed by default on Windows 10/Mac, but if it doesn't seem to be installed, please install it again.

---

# ライセンス / License
## 要約 / Summary

MIT License での配布なので利用制限、動作損害保証ともに一切ありません。

Since it is distributed under the MIT License, there are no usage restrictions, operation guarantees, or damage guarantees.