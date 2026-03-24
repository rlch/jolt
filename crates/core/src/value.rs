/// flutter_rust_bridge:non_opaque
#[derive(Debug, Clone, PartialEq)]
pub enum JsValue {
    Undefined,
    Null,
    Bool(bool),
    Int(i64),
    Float(f64),
    String(String),
    Array(Vec<JsValue>),
    Object(Vec<JsEntry>),
    Bytes(Vec<u8>),
}

/// flutter_rust_bridge:non_opaque
#[derive(Debug, Clone, PartialEq)]
pub struct JsEntry {
    pub key: String,
    pub value: JsValue,
}

impl JsValue {
    pub fn as_str(&self) -> Option<&str> {
        match self {
            JsValue::String(s) => Some(s),
            _ => None,
        }
    }

    pub fn as_f64(&self) -> Option<f64> {
        match self {
            JsValue::Float(f) => Some(*f),
            JsValue::Int(i) => Some(*i as f64),
            _ => None,
        }
    }

    pub fn as_i64(&self) -> Option<i64> {
        match self {
            JsValue::Int(i) => Some(*i),
            JsValue::Float(f) => Some(*f as i64),
            _ => None,
        }
    }

    pub fn as_bool(&self) -> Option<bool> {
        match self {
            JsValue::Bool(b) => Some(*b),
            _ => None,
        }
    }

    pub fn as_array(&self) -> Option<&[JsValue]> {
        match self {
            JsValue::Array(a) => Some(a),
            _ => None,
        }
    }

    pub fn as_object(&self) -> Option<&[JsEntry]> {
        match self {
            JsValue::Object(o) => Some(o),
            _ => None,
        }
    }

    pub fn is_null_or_undefined(&self) -> bool {
        matches!(self, JsValue::Null | JsValue::Undefined)
    }

    pub fn is_truthy(&self) -> bool {
        match self {
            JsValue::Undefined | JsValue::Null => false,
            JsValue::Bool(b) => *b,
            JsValue::Int(i) => *i != 0,
            JsValue::Float(f) => *f != 0.0 && !f.is_nan(),
            JsValue::String(s) => !s.is_empty(),
            JsValue::Array(_) | JsValue::Object(_) | JsValue::Bytes(_) => true,
        }
    }
}

impl From<&str> for JsValue {
    fn from(s: &str) -> Self {
        JsValue::String(s.to_owned())
    }
}

impl From<String> for JsValue {
    fn from(s: String) -> Self {
        JsValue::String(s)
    }
}

impl From<f64> for JsValue {
    fn from(f: f64) -> Self {
        JsValue::Float(f)
    }
}

impl From<i64> for JsValue {
    fn from(i: i64) -> Self {
        JsValue::Int(i)
    }
}

impl From<bool> for JsValue {
    fn from(b: bool) -> Self {
        JsValue::Bool(b)
    }
}

impl From<Vec<JsValue>> for JsValue {
    fn from(v: Vec<JsValue>) -> Self {
        JsValue::Array(v)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_as_str() {
        assert_eq!(JsValue::from("hello").as_str(), Some("hello"));
        assert_eq!(JsValue::Int(1).as_str(), None);
    }

    #[test]
    fn test_as_f64() {
        assert_eq!(JsValue::Float(2.72).as_f64(), Some(2.72));
        assert_eq!(JsValue::Int(42).as_f64(), Some(42.0));
        assert_eq!(JsValue::Null.as_f64(), None);
    }

    #[test]
    fn test_is_truthy() {
        assert!(!JsValue::Undefined.is_truthy());
        assert!(!JsValue::Null.is_truthy());
        assert!(!JsValue::Bool(false).is_truthy());
        assert!(!JsValue::Int(0).is_truthy());
        assert!(!JsValue::Float(0.0).is_truthy());
        assert!(!JsValue::from("").is_truthy());
        assert!(JsValue::Bool(true).is_truthy());
        assert!(JsValue::Int(1).is_truthy());
        assert!(JsValue::from("hi").is_truthy());
        assert!(JsValue::Array(vec![]).is_truthy());
    }

    #[test]
    fn test_is_null_or_undefined() {
        assert!(JsValue::Null.is_null_or_undefined());
        assert!(JsValue::Undefined.is_null_or_undefined());
        assert!(!JsValue::Int(0).is_null_or_undefined());
    }

    #[test]
    fn test_from_impls() {
        assert_eq!(JsValue::from("test"), JsValue::String("test".to_owned()));
        assert_eq!(JsValue::from(42i64), JsValue::Int(42));
        assert_eq!(JsValue::from(2.72f64), JsValue::Float(2.72));
        assert_eq!(JsValue::from(true), JsValue::Bool(true));
    }
}
