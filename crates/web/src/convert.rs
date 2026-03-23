use jolt_core::{JoltError, JsEntry, JsValue};
use wasm_bindgen::JsValue as WasmJsValue;

/// Convert a wasm_bindgen JsValue into our JsValue.
pub fn to_js_value(val: &WasmJsValue) -> Result<JsValue, JoltError> {
    if val.is_undefined() {
        Ok(JsValue::Undefined)
    } else if val.is_null() {
        Ok(JsValue::Null)
    } else if let Some(b) = val.as_bool() {
        Ok(JsValue::Bool(b))
    } else if let Some(f) = val.as_f64() {
        if f.fract() == 0.0 && f >= i64::MIN as f64 && f <= i64::MAX as f64 {
            Ok(JsValue::Int(f as i64))
        } else {
            Ok(JsValue::Float(f))
        }
    } else if let Some(s) = val.as_string() {
        Ok(JsValue::String(s))
    } else if js_sys::Array::is_array(val) {
        let arr = js_sys::Array::from(val);
        let mut items = Vec::with_capacity(arr.length() as usize);
        for i in 0..arr.length() {
            items.push(to_js_value(&arr.get(i))?);
        }
        Ok(JsValue::Array(items))
    } else if val.is_object() {
        let obj = js_sys::Object::from(val.clone());
        let entries_arr = js_sys::Object::entries(&obj);
        let mut entries = Vec::new();
        for i in 0..entries_arr.length() {
            let pair = js_sys::Array::from(&entries_arr.get(i));
            let key = pair.get(0).as_string().unwrap_or_default();
            let value = to_js_value(&pair.get(1))?;
            entries.push(JsEntry { key, value });
        }
        Ok(JsValue::Object(entries))
    } else {
        Ok(JsValue::Undefined)
    }
}

/// Convert our JsValue into a wasm_bindgen JsValue.
pub fn from_js_value(val: &JsValue) -> Result<WasmJsValue, JoltError> {
    match val {
        JsValue::Undefined => Ok(WasmJsValue::undefined()),
        JsValue::Null => Ok(WasmJsValue::null()),
        JsValue::Bool(b) => Ok(WasmJsValue::from(*b)),
        JsValue::Int(i) => Ok(WasmJsValue::from(*i as f64)),
        JsValue::Float(f) => Ok(WasmJsValue::from(*f)),
        JsValue::String(s) => Ok(WasmJsValue::from_str(s)),
        JsValue::Array(items) => {
            let arr = js_sys::Array::new_with_length(items.len() as u32);
            for (i, item) in items.iter().enumerate() {
                arr.set(i as u32, from_js_value(item)?);
            }
            Ok(arr.into())
        }
        JsValue::Object(entries) => {
            let obj = js_sys::Object::new();
            for entry in entries {
                js_sys::Reflect::set(&obj, &WasmJsValue::from_str(&entry.key), &from_js_value(&entry.value)?)
                    .map_err(|e| {
                        JoltError::ConversionError(format!("Failed to set property: {:?}", e))
                    })?;
            }
            Ok(obj.into())
        }
        JsValue::Bytes(bytes) => {
            let arr = js_sys::Uint8Array::new_with_length(bytes.len() as u32);
            arr.copy_from(bytes);
            Ok(arr.into())
        }
    }
}
