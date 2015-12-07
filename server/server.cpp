#include "gen-cpp/tproxy.h"
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TSimpleServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TBufferTransports.h>

using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;
using namespace ::apache::thrift::server;

using boost::shared_ptr;

using namespace  ::tproxy;

class tproxyHandler : virtual public tproxyIf {
 public:
  tproxyHandler() {
    // Your initialization goes here
  }

  void getHelloWorld(std::string& _return, const std::string& yourname) {
    // Your implementation goes here
    printf("getHelloWorld\n");

	std::string buf = "Hello world from port 10002 server (" + yourname + ")\n";
	_return = buf;
  }

};

int main(int argc, char **argv) {
  int port = 10002;
  shared_ptr<tproxyHandler> handler(new tproxyHandler());
  shared_ptr<TProcessor> processor(new tproxyProcessor(handler));
  shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
  shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
  shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

  TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
  server.serve();
  return 0;
}

