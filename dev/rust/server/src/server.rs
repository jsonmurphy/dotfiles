use std::{io::Read, net::TcpListener, convert::TryFrom};
use crate::http::{Response, Request, StatusCode, ParseError};

pub struct Server {
    address: String,
}

pub trait Handler {
    fn handle_request(&mut self, request: &Request) -> Response;
    fn handle_bad_request(&mut self, e: &ParseError) -> Response {
        println!("Failed to parse request: {}", e);
        Response::new(StatusCode::BadRequest, None)
    }
}

impl Server {
    pub fn new <T: Into<String>> (address: T) -> Self {
        Server{ address: address.into() }
    }

    pub fn run (self, mut handler: impl Handler) {
        println!("Listening on {}", self.address);

        let listener = TcpListener::bind(&self.address).unwrap();

        loop {
            match listener.accept() {
                Ok((mut stream, _)) => {
                    let mut buffer  = [0; 1024];
                    match stream.read(&mut buffer) {
                        Ok(_) => {
                            println!("Received a request: {}", String::from_utf8_lossy(&buffer));
                            let res = match Request::try_from(&buffer[..]) {
                                Ok(req) => {
                                    handler.handle_request(&req)
                                },
                                Err(e) => {
                                    handler.handle_bad_request(&e)
                                },
                            };
                            if let Err(e) = res.send(&mut stream) {
                                println!("Failed to send response: {}", e)
                            }
                        },
                        Err(e) => println!("Failed to read from connection: {}", e),
                    };
                },
                Err(e) => println!("Failed to establish connection: {}", e),
            }
        }
    }
}
