function find_gpp()
    if is_windows()
        #TODO, is this really the hardcoded way to get the WinRPM path to g++ ?
        gpp = Pkg.dir("WinRPM","deps","usr","x86_64-w64-mingw32","sys-root","mingw","bin","g++")
        if !isfile(gpp*".exe")
            info("g++ not found. installing gcc-c++ using WinRPM")
            @eval using WinRPM
            WinRPM.install("gcc-c++"; yes = true)
            WinRPM.install("gcc"; yes = true)
            WinRPM.install("headers"; yes = true)
        end
        RPMbindir = Pkg.dir("WinRPM","deps","usr","x86_64-w64-mingw32","sys-root","mingw","bin")
        incdir = Pkg.dir("WinRPM","deps","usr","x86_64-w64-mingw32","sys-root","mingw","include")
        push!(Base.Libdl.DL_LOAD_PATH, RPMbindir) # TODO does this need to be reversed?
        ENV["PATH"] = ENV["PATH"] * ";" * RPMbindir;
        return gpp, incdir, "dll"
    end
    if is_unix()
        if success(`g++ --version`)
            return "g++", "", is_apple() ? "dylib" : "so"
        else
            error("no g++ found. Please install a version > 4.5")
        end
    end
end

# generate wrapper code
include("generate_code.jl")
path = dirname(@__FILE__)
libo = joinpath(path, "build", "earcut.o")
# there are some platforms which behave weird when removing files.
# since it doesn't need to be removed, we can allow it to fail
save_rm(file) = try
    rm(file)
catch e
    warn(e)
end

cd(path) do
    gpp, incdir, ext = find_gpp()
    base = joinpath(path, "build")
    isdir(base) || mkdir(base)
    libo = joinpath(base, "earcut.o")
    isfile(libo) && save_rm(libo)
    run(`$gpp -c -fPIC -std=c++11 cwrapper.cpp -I $incdir -o $libo`)
    lib = joinpath(base, "earcut.$ext")
    isfile(lib) && save_rm(lib)
    run(`$gpp -shared -o $lib $libo`)
    info("Compiled EarCut successfully!")
end
