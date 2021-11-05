use std::str::FromStr;

#[derive(Debug)]
pub enum HttpMethod {
    GET,
    DELETE,
    PUT,
    POST,
    PATCH,
    HEAD,
    CONNECT,
    OPTIONS,
    TRACE
}

impl FromStr for HttpMethod {
    type Err = MethodError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "GET" => Ok(Self::GET),
            "DELETE" => Ok(Self::DELETE),
            "PUT" => Ok(Self::PUT),
            "POST" => Ok(Self::POST),
            "PATCH" => Ok(Self::PATCH),
            "HEAD" => Ok(Self::HEAD),
            "CONNECT" => Ok(Self::CONNECT),
            "OPTIONS" => Ok(Self::OPTIONS),
            "TRACE" => Ok(Self::TRACE),
            _ => Err(MethodError)
        }
    }
}

pub struct MethodError;
