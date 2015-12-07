#include <iostream>
#include <cstring>
#include <stdlib.h>

#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>

#include "gen-cpp/tproxy.h"

using namespace apache::thrift;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;

std::string getHelloWorld(const std::string name);

int main(int argc, char* argv[])
{
	std::string name;
	if (argc < 2) {
		name = "YOURNAME";
	} else {
		name = argv[1];
	}

	std::cout << getHelloWorld(name) << "\n"; 
	return (0);
}

std::string getHelloWorld(const std::string name)
{
	boost::shared_ptr<TTransport> socket(new TSocket("127.0.0.1", 10001));
	boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
	boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
	tproxy::tproxyClient client(protocol);

	transport->open();

	std::string p;
	client.getHelloWorld(p, name);

	return p;

}

