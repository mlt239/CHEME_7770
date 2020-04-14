#Run this to check if the stoichiometric matrix is elementally balanced!
using DelimitedFiles
s = readdlm("stoichiometric.txt");
a = readdlm("atom.txt");

answer1 = transpose(a)*s # This is the result without boundary species, still balanced for internal reactions

#notice that the above is not fully 0. To solve this, need to account for
#boundary species

s2 = readdlm("s_v2.txt");
a2 = readdlm("a_v2.txt");

answer2 = transpose(a2)*s2 # results with boundary species
