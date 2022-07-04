function noiseestimation(darkframe, maskindices, CorrectionInverseMatrix)


    tprint(Panel(RenderableText("\nWe will estimate the noise in the darkframe after having performed colour correction and specified the mask.
    \nBefore proceeding:
    \n • Ensure that the screen shows no activity.
    \n • Make sure the camera is correctly pointing to the screen.
    \nWe will now record a few frames. Press enter to continue with recording.",width=60),
    title="{bold}Record darkframe{/bold}", 
    title_justify=:centre))

    pressanykey()

    webcamimages, timeinsecs, redflux, greenflux, blueflux = recordImages(darkframe, 4, maskindices, A=CorrectionInverseMatrix, dev=GLOBALDEV);

    stdred = std(redflux)

    stdblue = std(blueflux)
    
    tprint(RenderableText("Standard deviation for {blue}blue{/blue} flux is " * string(stdred)))
    tprint(RenderableText("Standard deviation for {red}red{/red} flux is " * string(stdblue)))
    
    sleep(3)

    stdblue, stdred

end