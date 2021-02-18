extern crate grpc;
extern crate log;
extern crate src_proto_echo_service;
extern crate tls_api_stub;

use std::env;
use std::str::FromStr;
use std::thread;

use log::*;
use src_proto_echo_service::*;

struct EchoImpl;

impl EchoService for EchoImpl {
    fn echo(&self, _m: grpc::RequestOptions, req: Request) -> grpc::SingleResponse<Response> {
        let mut r = Response::new();
        info!("YAY");
        let message = if req.get_message().is_empty() {
            "wat"
        } else {
            req.get_message()
        };
        r.set_message(message.to_string());
        grpc::SingleResponse::completed(r)
    }
}

fn main() {
    let mut server = grpc::ServerBuilder::<tls_api_stub::TlsAcceptor>::new();
    let port = u16::from_str(&env::args().nth(1).unwrap_or_else(|| "8080".to_owned())).unwrap();
    server.http.set_port(port);
    server.add_service(EchoServiceServer::new_service_def(EchoImpl));
    server.http.set_cpu_pool_threads(4);
    let server = server.build().expect("server");
    let port = server.local_addr().port().unwrap();
    println!("Echo server started on port {}", port);

    loop {
        thread::park();
    }
}
