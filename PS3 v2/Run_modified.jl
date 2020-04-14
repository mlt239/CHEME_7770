using DelimitedFiles
include("Flux.jl")

s = readdlm("stoichiometric.txt");

# These species bounds are 0 because we're at steady-state
species_bounds_array = [
  0.0	0.0	;	# 1 AMP
  0.0	0.0	;	# 2 Arginine
  0.0	0.0	;	# 3 Arginosuccinate
  0.0	0.0	;	# 4 Aspartate
  0.0	0.0	;	# 5 ATP
  0.0	0.0	;	# 6 Carbamoyl phosphate
  0.0	0.0	;	# 7 Citrulline
  0.0	0.0	;	# 8 Diphosphate
  0.0	0.0	;	# 9 Fumarate
  0.0	0.0	;	# 10 H2O
  0.0	0.0	;	# 11 Hydrogen
  0.0	0.0	;	# 12 NADP
  0.0	0.0	;	# 13 NADPH
  0.0	0.0	;	# 14 Nitric oxide
  0.0	0.0	;	# 15 Ornithine
  0.0	0.0	;	# 16 Orthophosphate
  0.0	0.0	;	# 17 Oxygen
  0.0	0.0	;	# 18 Urea
];

#Flux bounds array (mmol/gDW-hr)
E = 0.01*(1/1000); #need to convert to mmol/gDW from umol/gDW

flux_bounds_array = [
  0.0	E*(203*3600)*0.98920	;	# 1	ATP + Citrulline + Asparate > AMP + diphosphate + Arginosuccinate
  0.0	E*(34.5*3600)	;	# 2	Arginosuccinate > Fumarate + Arginine
  0.0	E*(249*3600)*0.14530	;	# 3	Arginine + H2O > Ornithine + Urea
  0.0	E*(88.1*3600)	;	# 4	Ornithine + Carbamoyl Phosphate > Citrulline +orthophosphate
  0.0	E*(13.7*3600)*0.98304 ;	# 5	2 Arginine + 3 NADPH + 3 H + 4 O2 > 2 Citrulline + 2 Nitric oxide + 3 NADP + 4 H2O
  0.0	E*(13.7*3600)	;	# 6	2 Citrulline + 2 Nitric oxide + 3 NADP + 4 H2O > 2 Arginine + 3 NADPH + 3 H + 4 O2
#Next, we have the exchanges. These are defined in the problem
  0.0	10.0	;	# 7	outside > Carbamoyl phosphate (b1)
  0.0	10.0	;	# 8	outside > Asparate (b2)
  0.0	10.0	;	# 9	Fumarate > outside (b3)
  0.0	10.0	;	# 10 Urea > outside (b4)
#So these down here are necessary to generate fluxes, also defined in problem
  -10.0	10.0	;	# 11	> NADPH*
  -10.0	10.0	;	# 12	> ATP
  -10.0	10.0	;	# 13	> H*
  -10.0	10.0	;	# 14	> H2O*
  -10.0	10.0	;	# 15	> Oxygen*
  -10.0	10.0	;	# 16	AMP >
  -10.0	10.0	;	# 17	Diphosphate >
  -10.0	10.0	;	# 18	NADP >*
  -10.0	10.0	;	# 19	Nitric oxide >*
  -10.0	10.0	;	# 20	Orthophosphate >
];

objective_array = [
  0.0;	# 1	ATP + Citrulline + Asparate > AMP + diphosphate + Arginosuccinate
  0.0;	# 2	Arginosuccinate > Fumarate + Arginine
  0.0;	# 3	Arginine + H2O > Ornithine + Urea
  0.0;	# 4	Ornithine + Carbamoyl Phosphate > Citrulline +orthophosphate
  0.0;	# 5	2 Arginine + 3 NADPH + 3 H + 4 O2 > 2 Citrulline + 2 Nitric oxide + 3 NADP + 4 H2O
  0.0;	# 6	2 Citrulline + 2 Nitric oxide + 3 NADP + 4 H2O > 2 Arginine + 3 NADPH + 3 H + 4 O2
  0.0;	# 7	outside > Carbamoyl phosphate (b1)
  0.0;	# 8	outside > Asparate (b2)
  0.0;	# 9	Fumarate > outside (b3)
  -1.0;	# 10 Urea > outside (b4) <---- That's what we're trying to maximize
  0.0;	# 11	> NADPH
  0.0;	# 12	> ATP
  0.0;	# 13	> H
  0.0;	# 14	> H2O
  0.0;	# 15	> Oxygen
  0.0;	# 16	AMP >
  0.0;	# 17	Diphosphate >
  0.0;	# 18	NADP >
  0.0;	# 19	Nitric oxide >
  0.0;	# 20	Orthophosphate >
];

(objective_value, calculated_flux_array, dual_value_array, uptake_array, exit_flag, status_flag) = calculate_optimal_flux_distribution(s, flux_bounds_array, species_bounds_array, objective_array)
