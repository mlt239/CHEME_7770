#this script is for plotting values of X in the three system AC-DC circuit
#system presented in the paper.

using DifferentialEquations
using Plots

gr(dpi = 300)
function f(d, u, p, t)
    #dx/dt parameters
    a_x = 0.039
    b_x = 6.1
    z_x = 0.000013
    n_zx = 2.32
    #dy/dt paramters
    a_y = 0.0043
    b_y = 5.7
    x_y = 0.00079
    n_xy = 2.0
    delta_y = 1.05
    #dz/dt parameters
    delta_z = 1.04
    x_z = 0.12
    n_xz = 2.0
    y_z = 0.011
    n_yz = 2.0

    S = 100 #Change this for the problem!

    x = u[1]
    y = u[2]
    z = u[3]
    dx = d[1]
    dy = d[2]
    dz = d[3]

    d[1] = @. -u[1] + (a_x + b_x*S)/(1 + S + (u[3]/z_x)^n_zx) #dx/dt
    d[2] = @. -delta_y*u[2] + ((a_y + b_y*S)/(1 + S + (u[1]/x_y)^n_xy))   #dy/dt
    d[3] = @. -delta_z*u[3] + 1/(1 + ((u[1]/x_z)^n_xz) + ((u[2]/y_z)^n_yz)) #dz/dt

end

x₀ = [0.0, 0.0, 0.0]  #initial state vectors
tspan=(0.0,60.0)             #time span

problem = ODEProblem(f, x₀, tspan) #define the ODE
sol = solve(problem) #solve it!

#As of now, it plots X, Y, and Z. To only plot X, throw in a vars = 1 in the
#arguments for plot
graph = plot(sol, xaxis = "Time", yaxis = "Value (X, Y, Z)", label = ["X" "Y" "Z"])
display(graph)
#savefig(graph, "./2e.png")
