setlocal EnableDelayedExpansion

del .\examples\CMakeLists.txt
copy examples_CMakeLists.txt .\examples\CMakeLists.txt
cd examples

:: Compile example that links zenoh
cmake -GNinja -DCMAKE_BUILD_TYPE=Release .
if errorlevel 1 exit 1
cmake --build . --config Release
if errorlevel 1 exit 1

:: Run examples that exit immediately
.\z_info.exe
if errorlevel 1 exit 1
.\z_bytes.exe
if errorlevel 1 exit 1
