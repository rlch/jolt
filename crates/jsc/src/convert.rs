use jolt_core::{JoltError, JsEntry, JsValue};
use rusty_jsc::{JSContext, JSObject, JSValue as JscValue};

/// Convert a JSC JSValue into our JsValue.
pub fn to_js_value(ctx: &JSContext, val: &JscValue) -> Result<JsValue, JoltError> {
    if val.is_undefined(ctx) {
        Ok(JsValue::Undefined)
    } else if val.is_null(ctx) {
        Ok(JsValue::Null)
    } else if val.is_boolean(ctx) {
        Ok(JsValue::Bool(val.to_bool(ctx)))
    } else if val.is_number(ctx) {
        let n = val
            .to_number(ctx)
            .map_err(|e| JoltError::ConversionError(format!("Failed to convert number: {:?}", e)))?;
        // If the number is an integer, represent it as Int
        if n.fract() == 0.0 && n >= i64::MIN as f64 && n <= i64::MAX as f64 {
            Ok(JsValue::Int(n as i64))
        } else {
            Ok(JsValue::Float(n))
        }
    } else if val.is_string(ctx) {
        let s = val
            .to_string(ctx)
            .map_err(|e| JoltError::ConversionError(format!("Failed to convert string: {:?}", e)))?;
        Ok(JsValue::String(s.to_string()))
    } else if val.is_array(ctx) {
        let obj = val
            .to_object(ctx)
            .map_err(|e| JoltError::ConversionError(format!("Failed to convert array: {:?}", e)))?;
        let length_val = obj.get_property(ctx, "length");
        let length = length_val
            .to_number(ctx)
            .map_err(|e| JoltError::ConversionError(format!("Failed to get array length: {:?}", e)))? as u32;
        let mut items = Vec::with_capacity(length as usize);
        for i in 0..length {
            let item = obj
                .get_property_at_index(ctx, i)
                .map_err(|e| JoltError::ConversionError(format!("Failed to get array item: {:?}", e)))?;
            items.push(to_js_value(ctx, &item)?);
        }
        Ok(JsValue::Array(items))
    } else {
        // Must be an object
        let mut obj = val
            .to_object(ctx)
            .map_err(|e| JoltError::ConversionError(format!("Failed to convert object: {:?}", e)))?;
        let names = obj.get_property_names(ctx);
        let mut entries = Vec::with_capacity(names.len());
        for name in names {
            let prop = obj.get_property(ctx, name.as_str());
            entries.push(JsEntry { key: name, value: to_js_value(ctx, &prop)? });
        }
        Ok(JsValue::Object(entries))
    }
}

/// Convert our JsValue into a JSC JSValue.
pub fn from_js_value(ctx: &JSContext, val: &JsValue) -> Result<JscValue, JoltError> {
    match val {
        JsValue::Undefined => Ok(JscValue::undefined(ctx)),
        JsValue::Null => Ok(JscValue::null(ctx)),
        JsValue::Bool(b) => Ok(JscValue::boolean(ctx, *b)),
        JsValue::Int(i) => Ok(JscValue::number(ctx, *i as f64)),
        JsValue::Float(f) => Ok(JscValue::number(ctx, *f)),
        JsValue::String(s) => Ok(JscValue::string(ctx, s.as_str())),
        JsValue::Array(items) => {
            let jsc_items: Vec<JscValue> = items
                .iter()
                .map(|item| from_js_value(ctx, item))
                .collect::<Result<_, _>>()?;
            let arr = JSObject::new_array(ctx, &jsc_items)
                .map_err(|e| JoltError::ConversionError(format!("Failed to create array: {:?}", e)))?;
            Ok(arr.to_jsvalue())
        }
        JsValue::Object(entries) => {
            let obj = JSObject::new(ctx);
            for entry in entries {
                let jsc_val = from_js_value(ctx, &entry.value)?;
                obj.set_property(ctx, entry.key.as_str(), jsc_val)
                    .map_err(|e| JoltError::ConversionError(format!("Failed to set property: {:?}", e)))?;
            }
            Ok(obj.to_jsvalue())
        }
        JsValue::Bytes(bytes) => {
            // Convert bytes to a JS array of numbers
            let jsc_items: Vec<JscValue> = bytes
                .iter()
                .map(|b| JscValue::number(ctx, *b as f64))
                .collect();
            let arr = JSObject::new_array(ctx, &jsc_items)
                .map_err(|e| JoltError::ConversionError(format!("Failed to create bytes array: {:?}", e)))?;
            Ok(arr.to_jsvalue())
        }
    }
}
