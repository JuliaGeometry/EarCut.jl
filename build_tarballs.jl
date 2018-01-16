using BinaryBuilder
platforms = [
  BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS(),
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64)
]
sources = [
  "https://github.com/JuliaGeometry/EarCut.jl.git" =>
"4db9500d402151d19b831983a6de94fdeb9435ce",
]
script = raw"""
cd $WORKSPACE/srcdir
cd EarCut.jl/deps/
g++ -c -fPIC -std=c++11 cwrapper.cpp -o earcut.o
g++ -shared -o earcut.so earcut.o
mv earcut.so $DESTDIR
exit
if [ $target = "x86_64-w64-mingw32" ]; then
cd $WORKSPACE/srcdir
g++ -c -fPIC -std=c++11 cwrapper.cpp -o earcut.o
g++ -shared -o earcut.dll earcut.o
mv earcut.dll $DESTDIR
exit
fi
if [ $target = "x86_64-w64-mingw32" ]; then
cd $WORKSPACE/srcdir
ls
cd EarCut.jl/
ls
cd deps/
ls
g++ -c -fPIC -std=c++11 cwrapper.cpp -o earcut.o
g++ -shared -o earcut.dll earcut.o
mv earcut.dll  $DESTDIR
exit
fi
"""
products = prefix -> [
	LibraryProduct(prefix,"earcut")
]
autobuild(pwd(), "EarCut", platforms, sources, script, products)
