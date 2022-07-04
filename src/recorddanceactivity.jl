function recorddanceactivity(darkframe, maskindices, CorrectionInverseMatrix, σblue, σred)

    local webcamimages, timeinsecs, redflux, greenflux, blueflux = recordImages(darkframe, 30, maskindices, A=CorrectionInverseMatrix, dev=GLOBALDEV);

    
    nlags = length(timeinsecs)-1

    delays = collect([2^(i/3)*0.46125 for i in -1:13])

    out = infer(map(Float64, timeinsecs),
          map(Float64, timeinsecs),
          map(Float64, blueflux),
          map(Float64, redflux),
          map(Float64, σblue * ones(length(timeinsecs))),
          map(Float64, σred * ones(length(timeinsecs))),
          subset = 75, delays = delays, seed = 1)

        
    fig = GLMakie.Figure(backgroundcolor = :black)

    display(fig)

    ax1 = Axis(fig[1,1], backgroundcolor = :black, title = "Geschätzte Zeitverschiebung (1)", xlabel = "Zeit", ylabel = "Wahrscheinlichkeit")
    ax2 = Axis(fig[2,1], backgroundcolor = :black, title = "Geschätzte Zeitverschiebung (2)", xlabel = "Zeit", ylabel = "Wahrscheinlichkeit")

    lines!(ax1, timeinsecs[1:nlags],exp.(crosscor(blueflux,redflux,1:nlags)),color = :green)

    lines!(ax2, delays, getprobabilities(out), color = :green)


    fontsize_theme = Theme(fontsize = 35, fontcolor=:white, textcolor=:white)

    set_theme!(fontsize_theme)


    display(fig)   

end