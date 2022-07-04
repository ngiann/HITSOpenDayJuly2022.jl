#using Random 

function infer(tblue, tred, yblue, yred, σblue, σred; subset = 75, delays = delays, seed = 1)

    @assert(length(tblue) == length(yblue))

    @assert(length(tred) == length(yred))

    # organise data

    rg = MersenneTwister(seed)

    idx  = [randperm(rg, length(yblue))[1:subset], randperm(rg, length(yred))[1:subset]]

    yobs = [yblue[idx[1]], yred[idx[2]]]
    
    tobs = [tblue[idx[1]], tred[idx[2]]]
    
    σobs = [σblue[idx[1]], σred[idx[2]]]

    # call GPCC

    out = @showprogress pmap(d -> (@suppress performcv(tobs, yobs, σobs, iterations=1000, numberofrestarts=3, delays = [0; d], kernel = GPCC.matern32, numberoffolds=5, rhomax=1000)), delays)


end
