#!/bin/bash

BASEDIR=$PWD
CPPOPTS="-fPIC -std=c++11 -Wall -I /usr/local/include"
LDOPTS="-L /usr/local/lib"


cd thrift
thrift -gen erl -gen cpp tproxy.thrift
cd $BASEDIR

cd tproxy
if [ -e ./rel/tproxy/bin/tproxy ]; then
./rel/tproxy/bin/tproxy stop
fi
rm -rf rel
mkdir -p rel
./rebar compile
cd rel
../rebar create-node nodeid=tproxy
cp ../reltool.config .
../rebar generate && ./tproxy/bin/tproxy start
cd $BASEDIR


CPP_FILES="client.cpp gen-cpp/tproxy_constants.cpp gen-cpp/tproxy.cpp gen-cpp/tproxy_types.cpp"
cd client
for f in $CPP_FILES ; do
	g++ $CPPOPTS -c $f
done
g++ $LDOPTS  -o client client.o tproxy*.o -lthrift
rm *.o
cd $BASEDIR



SV_CPP_FILES="server.cpp gen-cpp/tproxy_constants.cpp gen-cpp/tproxy.cpp gen-cpp/tproxy_types.cpp"
cd server
for f in $SV_CPP_FILES ; do
	g++ $CPPOPTS -c $f
done
g++ $LDOPTS  -o server server.o tproxy*.o -lthrift
rm *.o
cd $BASEDIR



