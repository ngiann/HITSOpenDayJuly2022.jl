module HITSOpenDayJuly2022

    global GLOBALDEV = "unset"

    import REPL
    using REPL.TerminalMenus
    using Term, Printf
    using StatsBase, Statistics, Random
    using VideoIO, Distributed
    using GLMakie
    using FixedPointNumbers, LinearAlgebra, ColorTypes#, ColorSchemeTools
    using DataStructures: CircularBuffer
    using Optim

    @everywhere using ProgressMeter, Suppressor, GPCC

    include("recordImages2.jl")

    include("getcorrection.jl")

    include("util.jl")

    include("terminalinterface.jl")

    include("infer.jl")

    include("noiseestimation.jl")

    function setcamera(x)
        global GLOBALDEV = x
    end

    function getcamera()
        GLOBALDEV
    end

    export start#infer, start, setcamera, getcamera


end
