default:
    @just --list

root := justfile_directory()

# Check all Rust crates compile
check:
    cargo check --workspace

# Run all Rust tests (single-threaded for JSC thread safety)
test:
    cargo test --workspace -- --test-threads=1

# Clean build artifacts
clean:
    cargo clean
