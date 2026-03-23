use jolt_core::{JoltError, JsEntry, JsValue};
use rquickjs::{Array, Ctx, FromJs, IntoJs, Object, Value};

/// Convert an rquickjs Value into our JsValue.
pub fn to_js_value<'js>(ctx: &Ctx<'js>, val: Value<'js>) -> Result<JsValue, JoltError> {
    if val.is_undefined() {
        Ok(JsValue::Undefined)
    } else if val.is_null() {
        Ok(JsValue::Null)
    } else if let Some(b) = val.as_bool() {
        Ok(JsValue::Bool(b))
    } else if let Some(i) = val.as_int() {
        Ok(JsValue::Int(i as i64))
    } else if val.is_float() {
        let f = val.as_float().unwrap_or(f64::NAN);
        Ok(JsValue::Float(f))
    } else if val.is_string() {
        let s: String = FromJs::from_js(ctx, val)
            .map_err(|e| JoltError::ConversionError(e.to_string()))?;
        Ok(JsValue::String(s))
    } else if val.is_array() {
        let arr = Array::from_js(ctx, val)
            .map_err(|e| JoltError::ConversionError(e.to_string()))?;
        let mut items = Vec::with_capacity(arr.len());
        for i in 0..arr.len() {
            let item: Value = arr.get(i)
                .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            items.push(to_js_value(ctx, item)?);
        }
        Ok(JsValue::Array(items))
    } else if val.is_object() {
        let obj = Object::from_js(ctx, val)
            .map_err(|e| JoltError::ConversionError(e.to_string()))?;
        let mut entries = Vec::new();
        for result in obj.props::<String, Value>() {
            let (key, value) = result
                .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            entries.push(JsEntry { key, value: to_js_value(ctx, value)? });
        }
        Ok(JsValue::Object(entries))
    } else {
        Ok(JsValue::Undefined)
    }
}

/// Convert our JsValue into an rquickjs Value.
pub fn from_js_value<'js>(ctx: &Ctx<'js>, val: &JsValue) -> Result<Value<'js>, JoltError> {
    match val {
        JsValue::Undefined => Ok(Value::new_undefined(ctx.clone())),
        JsValue::Null => Ok(Value::new_null(ctx.clone())),
        JsValue::Bool(b) => Ok(Value::new_bool(ctx.clone(), *b)),
        JsValue::Int(i) => {
            if *i >= i32::MIN as i64 && *i <= i32::MAX as i64 {
                Ok(Value::new_int(ctx.clone(), *i as i32))
            } else {
                Ok(Value::new_float(ctx.clone(), *i as f64))
            }
        }
        JsValue::Float(f) => Ok(Value::new_float(ctx.clone(), *f)),
        JsValue::String(s) => {
            let js_str = rquickjs::String::from_str(ctx.clone(), s)
                .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            Ok(js_str.into_value())
        }
        JsValue::Array(items) => {
            let arr = Array::new(ctx.clone())
                .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            for (i, item) in items.iter().enumerate() {
                let v = from_js_value(ctx, item)?;
                arr.set(i, v)
                    .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            }
            Ok(arr.into_value())
        }
        JsValue::Object(entries) => {
            let obj = Object::new(ctx.clone())
                .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            for entry in entries {
                let v = from_js_value(ctx, &entry.value)?;
                obj.set(entry.key.as_str(), v)
                    .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            }
            Ok(obj.into_value())
        }
        JsValue::Bytes(bytes) => {
            let arr = Array::new(ctx.clone())
                .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            for (i, byte) in bytes.iter().enumerate() {
                arr.set(i, *byte as i32)
                    .map_err(|e| JoltError::ConversionError(e.to_string()))?;
            }
            Ok(arr.into_value())
        }
    }
}

/// Newtype wrapper for JsValue to implement rquickjs traits (orphan rule).
pub struct JsValueWrapper(pub JsValue);

impl<'js> IntoJs<'js> for JsValueWrapper {
    fn into_js(self, ctx: &Ctx<'js>) -> rquickjs::Result<Value<'js>> {
        from_js_value(ctx, &self.0).map_err(|_e| rquickjs::Error::new_from_js("JsValue", "Value"))
    }
}

impl<'js> FromJs<'js> for JsValueWrapper {
    fn from_js(ctx: &Ctx<'js>, val: Value<'js>) -> rquickjs::Result<Self> {
        to_js_value(ctx, val)
            .map(JsValueWrapper)
            .map_err(|_e| rquickjs::Error::new_from_js("Value", "JsValue"))
    }
}
