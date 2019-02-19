# Debian9 で L2TP over IPSec VPN Clientを利用する

* GCEおよびVMware Player上の Debian9 にて動作確認
* サーバは L2TP over IPsec VPN で、IKEv1 PSKを使用
* ローカルネットワーク以外の通信をVPN経由にするルーティング設定

### 設定

	$ cp config.example config
	$ vim config

### インストール

	$ ./install.sh

### 設定適用

	$ ./configure.sh

* NAT traversal を使用します。
* ike,esp の 暗号化の種類は 3des-sha1-modp1024 が設定してあります。これらはike-scanで調査することができます。

ike-scan の利用例

		$ sudo apt install ike-scan
		$ sudo systemctl stop strongswan
		$ sudo ike-scan [VPNサーバのIPアドレス]

### 接続

	$ ./connect.sh

基本、再起動後は接続済み

### ローカルネットワーク以外の通信をVPN経由にする

	$ ./route-vpn.sh

* 実行前の経路情報がカレントディレクトリのip-route-saveに保存されます。
* VPNのローカルネットワーク以外のすべてのローカルネットワークは既存のものが追加されます。
* 現在接続中のSSHクライアントへの経路は既存のものが追加されます。
* GCEのメタデータサーバの経路はeth0が設定されます。

### 元の経路に戻す

	$ ./route-restore.sh

### 外部からみえるIPアドレスのチェック

	$ ./check-ip.sh

# 備考

sudo ipsec status の実行結果がESTABLISHEDになるのにINSTALLEDにならない場合、
クライアントのIPアドレスを変えれば直ることがあります。

