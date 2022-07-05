# import REPL
# using REPL.TerminalMenus
# using Term
# using Printf
# using Suppressor, StatsBase, PyPlot

#GLOBALDEV = "/dev/video0" # SPECIFY CAMERA TO USE

include("darkframeprocedure.jl")
include("maskprocedure.jl")
include("recordcolour.jl")
include("recorddanceactivity.jl")


function start()

    @printf("Listing available cameras (v4l2 must be installed!)\n\n"
    )
    run(`v4l2-ctl --list-devices`)

    setcamera(userinput("Please specify which camera to use and press enter\n"))

    @printf("Camera set to %s\n", getcamera())





    tprint("Please wait until Julia pre-compiles functions")
    
    # do warmup
    @suppress recordImages_nodarkframe(1; A = Matrix(I, 3, 3), dev=GLOBALDEV)
    
    try 
     topmenu()
    catch(ex)
        tprint("{red bold}Did you follow the sequence of steps? Please try again{/red bold}\n")
        display(ex)
    finally  
        tprint("\nUse {green}start(){/green} to restart menu. Goodbye!\n")
            
    end
end


function topmenu()

    pink = (255, 53, 184)

    DONE_darkframe  = false
    DONE_mask       = false
    DONE_red        = false
    DONE_green      = false
    DONE_blue       = false
    DONE_colour_correction = false
    DONE_noise      = false

    darkframe = nothing

    maskindices = nothing

    yred, yblue, ygreen = zeros(3), zeros(3), zeros(3)

    stdblue, stdred = 0.0, 0.0

    CorrectionInverseMatrix = zeros(3, 3)

    while (true)

        # Clear terminal

        run(`clear`)

        # Present options

        tprint(Panel(RenderableText("\nPlease follow sequence of steps\n"), Panel(RenderableText("\n1 Record darkframe "*isdone(DONE_darkframe)*"\n\n2 Define mask indices "*isdone(DONE_mask)*"\n\n3{red} Record red colour{/red} "*isdone(DONE_red)*"\n\n4{green} Record green colour{/green} "*isdone(DONE_green)*"\n\n5{blue} Record blue colour{/blue} "*isdone(DONE_blue)*"\n\n6 Noise estimation "*isdone(DONE_noise)*"\n\n"), width=40, title="Setup",justify=:center),
        Panel(RenderableText("\n7 "*rainbow_maker("Record dance activity\n")),width=40, title="Main",justify=:center),
        title="{$pink bold}Top menu{/$pink bold}", 
        title_justify=:centre,subtitle="Choose 0 to exit",
        subtitle_style="dim",
        subtitle_justify=:left))


        # Wait for user to input choice

        aux = userinput("\nEnter digit choice:\n")

        # Call selected option or re-display options if invalid option

        if aux == "0" # Exit menu
        
            return
        
        elseif aux == "1" # Record darkframe
        
            DONE_darkframe, darkframe = darkframeprocedure()
        
        elseif aux == "2"  # Define mask indices
            
            DONE_mask, maskindices = maskprocedure()

        elseif aux == "3" &&  DONE_mask && DONE_darkframe
            
            DONE_red, yred = recordcolour("red", darkframe, maskindices)

            DONE_colour_correction = false

        elseif aux == "4" &&  DONE_mask && DONE_darkframe
            
            DONE_green, ygreen = recordcolour("green", darkframe, maskindices)

            DONE_colour_correction = false

        elseif aux == "5" &&  DONE_mask && DONE_darkframe
            
            DONE_blue, yblue = recordcolour("blue", darkframe, maskindices)

            DONE_colour_correction = false

        elseif aux == "6"# &&  DONE_mask && DONE_darkframe && DONE_colour_correction
            
            stdblue, stdred = noiseestimation(darkframe, maskindices, CorrectionInverseMatrix)

            DONE_noise = true

        elseif aux == "7" #&&  DONE_mask && DONE_darkframe && DONE_red && DONE_green && DONE_blue && DONE_noise

            recorddanceactivity(darkframe, maskindices, CorrectionInverseMatrix, stdblue, stdred)

        else

            # Do nothing, automatically re-displays options

        end


        # Check if ready to calculate colour correction
        if DONE_red && DONE_green && DONE_blue && ~DONE_colour_correction
            
            DONE_colour_correction = true

            tprint("\n"*RenderableText(rainbow_maker("Calculated colour correction!"))*"\n")
            local A = getcorrection(yred, ygreen, yblue)
            CorrectionInverseMatrix = A \ I
            sleep(3)
        end
    end



end










#########################################
#       Various utility functions       #         
#########################################

function pressanykey(text="")

    request(RadioMenu([text]))

end


function isdone(x)

    x ? "✓" : "×"

end


function userinput(text)

    @printf("%s", text)
    
    readline()

end


# copied from Term.jl documentation

function rainbow_maker(text) # hide
    _n = ceil(Int, length(text)/2)  # hide
    R = hcat(range(30, 255, length=_n), range(255, 60, length=_n))  # hide
    G =hcat(range(255, 60, length=_n), range(60, 120, length=_n))  # hide
    B = range(50, 255, length=length(text))  # hide
    out = ""  # hide
    for n in 1:length(text)  # hide
        r, g, b = Term.rint(R[n]), Term.rint(G[n]), Term.rint(B[n])  # hide
        out *= "{($r, $g, $b)}$(text[n]){/($r, $g, $b)}"  # hide
    end # hide
    return "{bold}"*out*"{/bold}"  # hide
end # hide
