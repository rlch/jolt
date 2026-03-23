default:
    @just --list

root := justfile_directory()

# Check all Rust crates compile
check:
    cargo check --workspace

# Run all Rust tests (single-threaded for JSC thread safety)
test:
    cargo test --workspace -- --test-threads=1

# Regenerate FRB Dart bindings + patch + freezed
frb:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ root }}/flutter_jolt"
    flutter_rust_bridge_codegen generate
    # FRB 2.11.1 bug: remove unsupported wasmBindgenName parameter
    sed -i'' 's/.*wasmBindgenName.*//' lib/src/rust/frb_generated.dart
    dart run build_runner build --delete-conflicting-outputs

# Build WASM for web
build-web:
    cd "{{ root }}/flutter_jolt" && flutter_rust_bridge_codegen build-web --dart-root . --rust-root rust

# Build WASM for web (release)
build-web-release:
    cd "{{ root }}/flutter_jolt" && flutter_rust_bridge_codegen build-web --dart-root . --rust-root rust --release

# Build Rust + regenerate FRB bindings
build:
    cargo check --workspace
    just frb

# Run Flutter analysis
analyze:
    cd "{{ root }}/flutter_jolt" && flutter analyze

# Run example app on macOS
run:
    cd "{{ root }}/flutter_jolt/example" && flutter run -d macos

# Run example app on web (requires build-web first)
run-web:
    #!/usr/bin/env bash
    set -euo pipefail
    # Symlink WASM pkg into example's web/ so Flutter dev server can find it
    ln -sfn "{{ root }}/flutter_jolt/web/pkg" "{{ root }}/flutter_jolt/example/web/pkg"
    cd "{{ root }}/flutter_jolt/example" && flutter run -d chrome \
        --web-header=Cross-Origin-Opener-Policy=same-origin \
        --web-header=Cross-Origin-Embedder-Policy=require-corp

# Run example app on a specific device
run-device device:
    cd "{{ root }}/flutter_jolt/example" && flutter run -d {{ device }}

# Clean build artifacts
clean:
    cargo clean
    cd "{{ root }}/flutter_jolt" && flutter clean
    cd "{{ root }}/flutter_jolt/example" && flutter clean
    rm -rf "{{ root }}/flutter_jolt/web/pkg"
