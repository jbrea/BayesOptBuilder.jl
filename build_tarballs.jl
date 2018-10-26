# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "BayesOptBuilder"
version = v"0.1.0"

# Collection of sources required to build BayesOptBuilder
sources = [
    "https://github.com/rmcantin/bayesopt.git" =>
    "1326549b68f27801b79984ca227f4183d984107d",

    "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2" =>
    "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBAYESOPT_BUILD_EXAMPLES=OFF -DBAYESOPT_BUILD_SHARED=ON -DNLOPT_BUILD_SHARED=ON bayesopt/ -DBOOST_ROOT=../boost_1_68_0
make -j$nprocs
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libbayesopt", :libbayesopt)
    LibraryProduct(prefix, "libnlopt", :libnlopt)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

