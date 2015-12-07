#!/bin/sh



cd thrift
thrift -gen erl -gen cpp tproxy.thrift
cd ..
