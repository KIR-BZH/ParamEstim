include("ParamEstim.jl");
using .ParamEstim

#==============================================================================
    viz_type::String => "best", "average", "original" or int(1~n_fitparam)
    show_all::Bool
    stdev::Bool (Only when viz_type == "average")
==============================================================================#

simulateAll(Sim,viz_type="average",show_all=false,stdev=true);