use super::server::Handler;
use crate::http::{Response, StatusCode, Request, HttpMethod};
use std::fs;

pub struct WebHandler {
    public_path: String
}

impl WebHandler {
    pub fn new(public_path: String) -> Self { Self { public_path } }

    fn read_file(&self, file_path: &str) -> Option<String> {
        let path = format!("{}/{}", self.public_path, file_path);
        fs::read_to_string(path).ok()
    }
}


impl Handler for WebHandler {
    fn handle_request(&mut self, request: &Request) -> Response {
        match request.method() {
            HttpMethod::GET => match request.path() {
                "/" => Response::new(StatusCode::Ok, self.read_file("index.html")),
                _ => Response::new(StatusCode::NotFound, None),
            }
            _ => Response::new(StatusCode::NotFound, None),
        }
    }
}
