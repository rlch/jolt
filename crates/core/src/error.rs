/// Errors produced by Jolt runtime operations.
///
/// flutter_rust_bridge:non_opaque
#[derive(Debug, thiserror::Error)]
pub enum JoltError {
    #[error("JS evaluation error: {message}")]
    EvalError {
        message: String,
        stack: Option<String>,
    },

    #[error("Type conversion error: {0}")]
    ConversionError(String),

    #[error("Runtime error: {0}")]
    RuntimeError(String),

    #[error("Function not found: {0}")]
    FunctionNotFound(String),
}
