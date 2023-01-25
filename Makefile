UWEBSOCKETS := /u/nhubbard/Build/uWebSockets

CXXFLAGS += -I$(UWEBSOCKETS)/src -I$(UWEBSOCKETS)/uSockets/src -lpthread -Wno-conversion -std=c++17
LDFLAGS += $(UWEBSOCKETS)/uSockets/*.o -lz

# pkg-config
ZMQ_CXXFLAGS += $(shell pkg-config --cflags libzmq libzmqpp)
ZMQ_LDFLAGS += $(shell pkg-config --libs libzmq libzmqpp)

# pkg-config
PROTOBUF_CXXFLAGS += $(shell pkg-config --cflags protobuf)
PROTOBUF_LDFLAGS += $(shell pkg-config --libs protobuf)

# OVERRIDE for ABI
ZMQ_LDFLAGS = /u/nhubbard/Build/zmqpp/gcc9/lib/libzmqpp.a $(shell pkg-config --libs libzmq)
PROTOBUF_LDFLAGS = /u/nhubbard/Build/protobuf-3.13.0/gcc9/lib/libprotobuf.a

# And merge
CXXFLAGS += $(ZMQ_CXXFLAGS) $(PROTOBUF_CXXFLAGS)
LDFLAGS += $(ZMQ_LDFLAGS) $(PROTOBUF_LDFLAGS)

all: DespecWS

DespecWS: DespecWS.o ucesb.pb.o
	$(CXX) -g $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.cpp ucesb.pb.h
	$(CXX) -g $(CXXFLAGS) -c -o $@ $<

%.o: %.cc
	$(CXX) -g $(CXXFLAGS) -c -o $@ $<

ucesb.pb.h ucesb.pb.cc: ../ucesb.proto
	protoc -I.. --cpp_out=. ../ucesb.proto

.PHONY: clean
clean:
	-rm DespecWS *.o ucesb.pb.h ucesb.pb.cc

