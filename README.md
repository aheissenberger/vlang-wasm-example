# V lang WASM Example

## setup

1. You need docker desktop to use this repository
2. In VS Code open `Remote-Container: Open folder in Container` to start a development enviroment which allows to compile V lang to WASM

## compile

`$ ./build_wasm.sh hello`

## run wasm

`$ wasmtime dist/hello.wasm`

## Notes

* `build_wasm.sh` and `wasm_include` is based on work done by https://github.com/zamfofex/v-wasm