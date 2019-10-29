#!/bin/bash

if [ ! -d "../examples/iOSExample/TokenCoreX" ]; then
  mkdir -p ../examples/iOSExample/TokenCoreX/Include
  mkdir -p ../examples/iOSExample/TokenCoreX/Libs
fi

pushd ../libs/secp256k1
if ! type "cargo-lipo" > /dev/null; then
    cargo install cargo-lipo
    rustup target add aarch64-apple-ios x86_64-apple-ios
fi
cargo lipo --release

cp target/universal/release/libsecp256k1.a ../../examples/iOSExample/TokenCoreX/Libs
popd

pushd ../tcx
RUST_BACKTRACE=1 cbindgen src/lib.rs -l c > cheader/tcx.h
cargo lipo --release

cp cheader/tcx.h ../examples/iOSExample/TokenCoreX/Include
cp ../target/universal/release/libtcx.a ../examples/iOSExample/TokenCoreX/Libs
popd
