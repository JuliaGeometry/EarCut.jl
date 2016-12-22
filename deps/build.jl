function find_gpp()
    @static if is_windows()
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
    @static if is_unix()
        if success(`g++ --version`)
            return "g++", "", "so"
        else
            error("no g++ found. Please install a version > 4.5")
        end
    end
end

# generate wrapper code
include("generate_code.jl")
path = dirname(@__FILE__)
cd(path) do
    gpp, incdir = find_gpp()
    libo = joinpath(path, "build", "earcut.o")
    isfile(libo) && rm(libo)
    run(`$gpp -c -fPIC -std=c++11 cwrapper.cpp -I $incdir -o $libo`)
    lib = joinpath(path, "build", "earcut.dll")
    isfile(lib) && rm(lib)
    run(`$gpp -shared -o $lib $libo`)
end
