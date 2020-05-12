#This script will generate the bifurcation plot for the bistable switch, using
#an initial steady state guess form Bistable.jl.
using Parameters
using DifferentialEquations
using StaticArrays
using Bifurcations
using Setfield
using DiffEqBase
using Plots

#Form our parameters vector
param = (a_x = 1.5,
b_x = 5.0,
S = 0.0,
z_x = 0.4,
n_zx = 2.7,
delta_z = 1.0,
x_z = 1.5,
n_xz = 2.7,
)

#S = 0 works, with initial guess (0, 1) for x and z
function f(u, p, t)
    @unpack a_x, b_x, S, z_x, n_zx, delta_z, x_z, n_xz = p
    x = u[1]
    z = u[2]
    dx = -x + (a_x + b_x*S)/(1 + S + (z/z_x)^n_zx)
    dz = -delta_z*z + 1/(1 + (x/x_z)^n_xz)
    return SVector(dx, dz)
end

u0 = SVector(0.0,1.0) #initial guess for steady state
tspan = (0.0, 300.0)
ode = ODEProblem(f, u0, tspan, param)

sol = solve(ode)

u02 = sol[end] #use our more accurate steady state as our initial guess

ode2 = ODEProblem(f, u02, tspan, param) #define the ODe problem
param_axis = @lens _.S #Which parameter are we varying? We're doing S
prob = BifurcationProblem(ode2, param_axis, (0.0, 2.0)) #Define a bifurcation problem
solver = init(prob;
start_from_nearest_root = true) #Not really sure what happens here, but it needs it

bifur = solve!(solver) #Solve it and cross your fingers it works

plt = plot(bifur, xaxis=("S"), yaxis=("X")) #generate bifurcation plot
savefig(plt, "./bifurcation.png")
#What are the saddle points?
point_list = sort!(special_intervals(solver), by=p->p.u0[end])
println(point_list[1])
println(point_list[2])
