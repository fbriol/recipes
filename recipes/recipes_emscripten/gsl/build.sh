#!/bin/bash

set -e
set -x

# Don't link to libgslcblas on windows
sed -i.bak "s/GSL_LIBADD=/GSL_LIBADD2=/g" configure.ac

rm -rf config.*
autoreconf -i
chmod +x configure

LIBS="-lcblas -lm" emconfigure ./configure --prefix=${PREFIX}  \
            --host=${HOST} || (cat config.log && exit 1)

make -j${CPU_COUNT}
# if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
# for f in $(find * -name "test.c"); do
#     TEST_DIR=$(dirname $f)
#     pushd $TEST_DIR;
#     SKIP=false
#     # See: https://savannah.gnu.org/bugs/index.php?56843
#     if [[ "$target_platform" == "linux-aarch64" && "$TEST_DIR" == "spmatrix" ]]; then
#         SKIP=true
#     fi
#     if [[ "$target_platform" == "linux-ppc64le" ]]; then
#         if [[ "$TEST_DIR" == "linalg" || "$TEST_DIR" == "multilarge_nlinear" || "$TEST_DIR" == "spmatrix" ]]; then
#             SKIP=true
#         fi
#     fi
#     if [[ "$SKIP" == true ]]; then
#         make check || true;
#     else
#         make check;
#     fi
#     popd;
# done
# fi

make install

ls -al "$PREFIX"/lib
ls -al "$PREFIX"/bin

# if [[ "$target_platform" == osx* ]]; then
#     ln -sf "libcblas.3.dylib" "$PREFIX/lib/libgslcblas.dylib"
#     ln -sf "libcblas.3.dylib" "$PREFIX/lib/libgslcblas.0.dylib"
#     rm "$PREFIX/lib/libcblas.3.dylib"
#     touch "$PREFIX/lib/libcblas.3.dylib"
# elif [[ "$target_platform" == linux* ]]; then
#     ln -sf "libcblas.so.3" "$PREFIX/lib/libgslcblas.so"
#     ln -sf "libcblas.so.3" "$PREFIX/lib/libgslcblas.so.0"
#     rm "$PREFIX/lib/libcblas.so.3"
#     touch "$PREFIX/lib/libcblas.so.3"
# elif [[ "$target_platform" == win* ]]; then
#     rm "$PREFIX/lib/gslcblas.dll.lib"
#     rm "$PREFIX/bin/gslcblas-0.dll"
#     cp "$PREFIX/lib/cblas.lib" "$PREFIX/lib/gslcblas.lib"
# fi