
#ifndef INTERFACE_HPP
#define INTERFACE_HPP

#include <vector>
#include <thread>
#include <memory>
#include <functional>
#include <zmq.hpp>
// #include <zhelpers.hpp>
#include <iostream>
#include <msgpack.hpp>
#include "Simulation_IO.hpp"
// template <typename T>

class Client {
public:
    Client()
        : ctx_(1),
          client_socket_(ctx_, ZMQ_REQ)
    {}

    void start() {
        
        std::cout << "Connecting to hello world server…" << std::endl;
        client_socket_.connect("tcp://localhost:5555");

    }

    
    void send_okay(){
        
        msgpack::sbuffer sbuf;
        msgpack::pack(sbuf, ("okay"));

        zmq::message_t msg(sbuf.size());
        memcpy(msg.data(), sbuf.data(), sbuf.size());

        client_socket_.send(msg);

    }

    void send_data(output* data){
        
        std::cout << "Sending data..." << std::endl;
        msgpack::sbuffer sbuf;
        msgpack::pack(sbuf, data->Mx);
        msgpack::pack(sbuf, data->My);
        msgpack::pack(sbuf, data->Mz);
        msgpack::pack(sbuf, data->Fx);
        msgpack::pack(sbuf, data->Fy);
        msgpack::pack(sbuf, data->Fz);

        zmq::message_t msg(sbuf.size());
        memcpy(msg.data(), sbuf.data(), sbuf.size());
        client_socket_.send(msg);

        std::cout << "Data received." << std::endl;
    }


    void receive_data(std::vector<std::vector<float>> &all_data){
        
        std::cout << "Waiting for data..." << std::endl;
        zmq::message_t request;

        //  Wait for next request from client
        client_socket_.recv(&request);
        msgpack::sbuffer sbuf;
        sbuf.write(static_cast<const char *>(request.data()), request.size());
        
        
        // serializes multiple objects using msgpack::packer.
        msgpack::sbuffer buffer;

        // deserializes these objects using msgpack::unpacker.
        msgpack::unpacker pac;

        // feeds the buffer.
        pac.reserve_buffer(sbuf.size());
        memcpy(pac.buffer(), sbuf.data(), sbuf.size());
        pac.buffer_consumed(sbuf.size());

        

        // now starts streaming deserialization.
        msgpack::object_handle oh;
        msgpack::object obj;
        std::vector<float> rvec;
        
        while(pac.next(oh)) {
            obj = oh.get();
    
            // convert it into statically typed object
            obj.convert(rvec);
            all_data.push_back(rvec);
            
        }
        
        std::cout << "Data received." << std::endl;
        
        // std::cout << all_data.size() << std::endl;

        // for(int i=0;i<all_data.size();i++){
        //     std::cout << all_data[i][0] << std::endl;
        // }
        
                
    }

    void pack_and_send(zmq::socket_t client, msgpack::sbuffer sbuf){
        
        zmq::message_t request(sbuf.size());
        memcpy(request.data(), sbuf.data(), sbuf.size());
        client.send(request);
    }

private:
    zmq::context_t ctx_;
    zmq::socket_t client_socket_;
};


#endif