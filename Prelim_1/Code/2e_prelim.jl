#this script is to determine different steady state values of Z at various
#S values, and then generate cell 1, 2, and 3 as per the instructions on the
#problem statement for 2e. Function g then uses those steady state values as
#the initial values for rapidly changing S to 100.

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

    S = 37500 #37500 for after the saddle node point and 0.075 for before Hopf

    #hopf occurs at about 0.3
    #saddle appears to occur at about 35000

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
function g(d, u, p, t)
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

    S = 100.0 #This one stays at 100 for the "rapid" change to 100

    x = u[1]
    y = u[2]
    z = u[3]
    dx = d[1]
    dy = d[2]
    dz = d[3]

    d[1] = @. -u[1] + (a_x + b_x*S)/(1 + S + (u[3]/z_x)^n_zx)
    d[2] = @. -delta_y*u[2] + ((a_y + b_y*S)/(1 + S + (u[1]/x_y)^n_xy))
    d[3] = @. -delta_z*u[3] + 1/(1 + ((u[1]/x_z)^n_xz) + ((u[2]/y_z)^n_yz))

end

x₀ = [0.0, 0.0, 0.0] #doesnt seem to matter if i start at 0s or 10, so do 0
tspan=(0.0,360.0)             #time span
problem = ODEProblem(f, x₀, tspan)
sol = solve(problem)
baseline = plot(sol, vars = (3),  xaxis = "Time", yaxis = "Value (Z)", label = "Z") #to check if I have a steady state at S

x00 = sol[end].*1.00 #Cell 1, need to increase by 1% to find steady state values
#before Hopf or after saddle node. Else, everything breaks.
x01 = sol[end].*1.25 #Cell 2
x02 = sol[end].*0.75 #Cell 3
tspan2=(0.0,120.0)

#The next section will plot baseline values for each of the "cells"
b1ode = ODEProblem(f, x00, tspan2)
b2ode = ODEProblem(f, x01, tspan2)
b3ode = ODEProblem(f, x02, tspan2)

sb1 = solve(b1ode)
sb2 = solve(b2ode)
sb3 = solve(b3ode)

baseline2 = plot(sb1, vars = (3),  xaxis = "Time", yaxis = "Value (Z)", label = "Cell 1")
plot!(sb2, vars = (3),  xaxis = "Time", yaxis = "Value (Z)", label = "Cell 2")
plot!(sb3, vars = (3),  xaxis = "Time", yaxis = "Value (Z)", label = "Cell 3")


#Now this section actually plots the new solution when S is suddenly changed to 100
problem1 = ODEProblem(g, x00, tspan2)
problem2 = ODEProblem(g, x01, tspan2)
problem3 = ODEProblem(g, x02, tspan2)

sol1 = solve(problem1)
sol2 = solve(problem2)
sol3 = solve(problem3)

graph = plot(sol1, vars = (3),  xaxis = "Time", yaxis = "Value (Z)", label = "Cell 1")
plot!(sol2, vars = (3),  xaxis = "Time", yaxis = "Value (Z)", label = "Cell 2")
plot!(sol3, vars = (3),  xaxis = "Time", yaxis = "Value (Z)", label = "Cell 3")

#S = 0.05 seems before the hopf bifurcation
