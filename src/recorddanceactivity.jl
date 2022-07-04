function recorddanceactivity(darkframe, maskindices, CorrectionInverseMatrix, σblue, σred)

    local webcamimages, timeinsecs, redflux, greenflux, blueflux = recordImages(darkframe, 30, maskindices, A=CorrectionInverseMatrix, dev=GLOBALDEV);

    PyPlot.figure(10) ; cla()
    PyPlot.title("Geschätzte Zeitverschiebung")
    nlags = length(timeinsecs)-1
    PyPlot.plot(timeinsecs[1:nlags],exp.(crosscor(blueflux,redflux,1:nlags)),".")

    PyPlot.figure(11) ; cla()

    delays = [2^(i/3)*0.46125 for i in -1:13]

    infer(map(Float64, timeinsecs),
          map(Float64, timeinsecs),
          map(Float64, blueflux),
          map(Float64, redflux),
          map(Float64, σblue * ones(length(timeinsecs))),
          map(Float64, σred * ones(length(timeinsecs))),
          subset = 75, delays = delays, seed = 1)

end