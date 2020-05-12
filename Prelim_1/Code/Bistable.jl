include("PhasePortraitV2.jl")

# This function will determine steady state values for the bistable switch,
#which will allow me to make initial guesses for the bifurcation problem.
function bistable(x1, x2)
    a_x = 1.5
    b_x = 5.0
    S = 0.0        
    z_x = 0.4
    n_zx = 2.7
    delta_z = 1.0
    x_z = 1.5
    n_xz = 2.7

    u = @. -x1 + (a_x + b_x*S)/(1 + S + (x2/z_x)^n_zx) #dx/dt
    v = @. -delta_z*x2 + 1/(1 + (x1/x_z)^n_xz)   #dz/dt

    return (u,v)
end

#Range of x1, x2 values
x1range = (0,10,15)          #Has the form (min, max, num points)
x2range = (0,10,15)          #Has the form (min, max, num points)
x₀ = ([5.0,5.0],)  #initial state vectors; a common must be included after the first array
tspan=(0.0,300.0)             #time span

#Call the phaseplot functon to construct the phase portrait
phaseplot(bistable, x1range, x2range, xinit=x₀, t=tspan, clines=true,
        norm=true, scale=0.5)
