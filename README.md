Sample code for masatoshiitoh's "Erlang advent calendar 2015" article.

For Japanese:

# 準備
Erlang/OTPとThrift 0.9.3をインストールします。

Erlang/OTP用のThriftライブラリはmake installでインストールされないので、
thrift-0.9.3のディレクトリを/usr/localにまるごとコピーしてください。
操作手順としては、こんな感じです。
```
curl -o thrift-0.9.3.zip https://codeload.github.com/apache/thrift/zip/0.9.3
unzip thrift-0.9.3.zip
cd thrift-0.9.3/
./bootstrap.sh
./configure
make
make install
cd ..
cp -rp thrift-0.9.3 /usr/local
```

# 実行
ThriftとErlang、g++が使用できる状態になったら、このリポジトリにあるrun-proxy.shを実行してください。

```
./run-proxy.sh
./server/server &
./client/client
```
run-proxy.shが起動するtproxyが、10001と10002の間を中継することで、
clientがTCP/10001をコールすると、TCP/10002で待ち受けているserverが呼び出されます。
