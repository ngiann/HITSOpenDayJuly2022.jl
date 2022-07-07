function noiseestimation(darkframe, maskindices, CorrectionInverseMatrix)


    tprint(Panel(RenderableText("\nWe will estimate the noise after having performed colour correction and specified the mask.
    \nBefore proceeding:
    \n • Ensure that the screen shows the constant disk image.
    \n • Make sure the camera is correctly pointing to the screen.
    \nWe will now record a few frames. Press enter to continue with recording.",width=60),
    title="{bold}Record darkframe{/bold}", 
    title_justify=:centre))

    pressanykey()

    webcamimages, timeinsecs, redflux, greenflux, blueflux = recordImages(darkframe, 4, maskindices, A=CorrectionInverseMatrix, dev=GLOBALDEV);

    stdred = std(redflux)

    stdblue = std(blueflux)
    
    tprint(RenderableText("Standard deviation for {blue}blue{/blue} flux is " * string(stdblue)))
    tprint(RenderableText("Standard deviation for {red}red{/red} flux is " * string(stdred)))
    
    sleep(3)

    stdblue, stdred

end