#!/bin/bash -e

rm -rf ./examples/CMakeLists.txt
cp  ./examples_CMakeLists.txt ./examples/CMakeLists.txt
cd examples

# Compile example that links zeno
cmake -GNinja -DCMAKE_BUILD_TYPE=Release .
cmake --build . --config Release

# Run example that exit immediately
./z_info
./z_bytes
