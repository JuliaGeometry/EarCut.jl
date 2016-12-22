# EarCut

[![Build Status](https://travis-ci.org/SimonDanisch/EarCut.jl.svg?branch=master)](https://travis-ci.org/SimonDanisch/EarCut.jl)

[![Coverage Status](https://coveralls.io/repos/SimonDanisch/EarCut.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/SimonDanisch/EarCut.jl?branch=master)

[![codecov.io](http://codecov.io/github/SimonDanisch/EarCut.jl/coverage.svg?branch=master)](http://codecov.io/github/SimonDanisch/EarCut.jl?branch=master)


Wrapper for [earcut.hpp](https://github.com/mapbox/earcut.hpp), a header only library for triangulating polygons.

License of wrapper: MIT
License of earcut.hpp: [ISC](https://github.com/JuliaGeometry/EarCut.jl.git/deps/earcut/LICENSE)

Install with:
```Julia
Pkg.clone("https://github.com/JuliaGeometry/EarCut.jl.git")
Pkg.build("EarCut")
Pkg.test("EarCut")
```

Usage:
```
using EarClip
using GeometryTypes
test = [Point2f0[...]] # some points defining a polygon. Must be a Vector{Vector{Point}}
triangle_faces = triangulate(polygon)
# then display with e.g. GLVisualize like this:
using GLVisualize, Colors; w = glscreen(); @async renderloop(w)
v = map(x-> Point3f0(x[1], x[2], 0), vcat(polygon...))
mesh = GLNormalMesh(vertices=v, faces=triangle_faces)
_view(visualize(mesh), camera = :orthographic_pixel)
GLAbstraction.center!(w, :orthographic_pixel)
```
