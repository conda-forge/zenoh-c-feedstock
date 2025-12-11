#!/bin/sh

# librt is needed for sem_* symbols
if [[ "${target_platform}" == linux-* ]] ; then
    export LDFLAGS="-lrt ${LDFLAGS}"
fi

mkdir build && cd build

cmake -GNinja ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS:BOOL=ON \
      -DZENOHC_INSTALL_STATIC_LIBRARY:BOOL=OFF \
      -DZENOHC_LIB_STATIC:BOOL=OFF \
      -DZENOHC_CARGO_FLAGS:STRING="--locked" \
      -DBUILD_TESTING:BOOL=ON \
      -DZENOHC_BUILD_WITH_SHARED_MEMORY:BOOL=ON \
      -DZENOHC_BUILD_WITH_UNSTABLE_API:BOOL=ON \
      $SRC_DIR

cmake --build .
cmake --install .

# Workaround to fix rpath of installed library on macos
# See https://github.com/conda-forge/zenoh-c-feedstock/issues/18
if [[ "${target_platform}" == osx-* ]]; then
    install_name_tool -id @rpath/libzenohc.dylib $PREFIX/lib/libzenohc.dylib
fi

cargo-bundle-licenses --format yaml --output ${SRC_DIR}/THIRDPARTY.yml

cmake --build . --target tests --config Release
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest -C Release --output-on-failure -E "(unit_z_api_alignment_test|build_z_build_static|unit_z_api_shm_test)"
fi
