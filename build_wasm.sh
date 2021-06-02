#!/bin/sh
CLANG_CMD="${WASI_SDK}/bin/clang"
FILE=$1
DEBUG=$2 # -g
v "src/${FILE}.v" $DEBUG -o "build/${FILE}.c"
$CLANG_CMD $DEBUG -w -O3 -D__linux__ \
        -target wasm32-unknown-wasi \
        --sysroot "$WASI_SDK/share/wasi-sysroot" \
        -D_WASI_EMULATED_SIGNAL \
        -lwasi-emulated-signal \
        -Iwasm_include \
        -Wl,--allow-undefined \
        -o "dist/${FILE}.wasm" \
        "build/${FILE}.c"