#!/bin/bash -e

cp  ./examples_CMakeLists.txt ./examples/
cd examples

# Compile example that links zeno
cmake -GNinja -DCMAKE_BUILD_TYPE=Release .
cmake --build . --config Release

# Run example that exit immediately
./z_info
./z_bytes
