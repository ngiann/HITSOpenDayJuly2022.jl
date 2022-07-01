module HITSOpenDayJuly2022

    
    import REPL
using REPL.TerminalMenus
using Term
using Printf
using Suppressor, StatsBase, Statistics, PyPlot
using PyPlot, VideoIO, Statistics, Distributed, Random
using GLMakie
using ColorTypes, FixedPointNumbers, LinearAlgebra, ColorSchemeTools
using DataStructures: CircularBuffer

    @everywhere using ProgressMeter, Suppressor, GPCC
    
     include("recordImages2.jl")

	include("getcorrection.jl")

include("util.jl")

include("terminalinterface.jl")


    include("infer.jl")

    export infer


end
