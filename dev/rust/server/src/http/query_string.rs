use std::collections::HashMap;

#[derive(Debug)]
pub struct QueryString<'buf> {
    data: HashMap<&'buf str, Value<'buf>>
}

impl<'buf> From<&'buf str> for QueryString<'buf> {
    fn from(s: &'buf str) -> Self {
        let mut data = HashMap::new();
        for sub_str in s.split('&') {
            let mut key = sub_str;
            let mut val = "";
            if let Some(i) = sub_str.find('=') {
                key = &sub_str[..i];
                val = &sub_str[i+1..]
            }
            data.entry(key)
                .and_modify(|v: &mut Value| match v {
                    Value::Single(prev) => {
                        *v = Value::Multiple(vec![prev, val]);
                    },
                    Value::Multiple(vec) => vec.push(val)
                })
                .or_insert(Value::Single(val));
        }
        Self {data}
    }
}

impl<'buf> QueryString<'buf> {
    pub fn _get(&self, key: &str) -> Option<&Value> {
        self.data.get(key)
    }
}

#[derive(Debug)]
pub enum Value<'buf> {
    Single(&'buf str),
    Multiple(Vec<&'buf str>)
}
