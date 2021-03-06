function simulate_all(Sim::Module;viz_type::String,show_all::Bool,stdev::Bool)
    if !isdir("./figure")
        mkdir("./figure")
    end

    if !(viz_type in ["best","average","original"])
        try
            parse(Int64,viz_type)
        catch
            error(
                "Error: viz_type ∈ {'best','average','original',int(1~n_fitparam)}"
            )
        end
    end

    p::Vector{Float64} = f_params()
    u0::Vector{Float64} = initial_values()

    n_file::Vector{Int} = []
    if viz_type != "original"
        try
            fitparam_files::Vector{String} = readdir("./fitparam")
            for file in fitparam_files
                if occursin(r"\d",file)
                    push!(n_file, parse(Int64,file))
                end
            end
        catch
            viz_type = "original"
        end
    end

    simulaitons_all::Array{Float64,4} = fill(
        NaN,(length(observables),length(n_file),length(Sim.t),length(Sim.conditions))
    )
    if length(n_file) > 0
        if length(n_file) == 1 && viz_type == "average"
            viz_type = "best"
        end
        for (i,nth_param_set) in enumerate(n_file)
            (Sim,successful) = validate(nth_param_set,p,u0)
            if successful
                for j=1:length(observables)
                    @inbounds simulaitons_all[j,i,:,:] = Sim.simulations[j,:,:]
                end
            end
        end

        best_fitness_all::Vector{Float64} = fill(Inf,length(n_file))
        for (i,nth_param_set) in enumerate(n_file)
            if isfile("./fitparam/$nth_param_set/best_fitness.dat")
                best_fitness_all[i] = readdlm(
                    "./fitparam/$nth_param_set/best_fitness.dat"
                )[1,1]
            end
        end
        best_param_set::Int = n_file[argmin(best_fitness_all)]
        write_best_fit_param(best_param_set,p,u0)

        if viz_type == "best"
            Sim,_ = validate(best_param_set,p,u0)
        elseif viz_type != "average" && parse(Int64,viz_type) <= length(n_file)
            Sim,_ = validate(parse(Int64,viz_type),p,u0)
        elseif viz_type != "average" && parse(Int64,viz_type) > length(n_file)
            error(
                @sprintf(
                    "n (%d) must be smaller than n_fitparam (%d)",
                    parse(Int64,viz_type), length(n_file)
                )
            )
        end

        if length(n_file) > 1
            save_param_range(n_file,p,u0)
        end
    else
        if Sim.simulate!(p,u0) !== nothing
            error("Simulation failed.")
        end
    end
    plotFunc_timecourse(
        Sim,length(n_file),viz_type,show_all,stdev,simulaitons_all
    )
end


function update_param(paramset::Int,p::Vector{Float64},u0::Vector{Float64})

    search_idx::Tuple{Array{Int64,1},Array{Int64,1}} = search_parameter_index()

    if isfile("./fitparam/$paramset/generation.dat")
        best_generation::Int64 = readdlm(
            "./fitparam/$paramset/generation.dat"
        )[1,1]
        best_indiv::Vector{Float64} = readdlm(
            @sprintf(
                "./fitparam/%d/fit_param%d.dat",
                paramset, best_generation
            )
        )[:,1]

        for (i,j) in enumerate(search_idx[1])
            @inbounds p[j] = best_indiv[i]
        end
        for (i,j) in enumerate(search_idx[2])
            @inbounds u0[j] = best_indiv[i+length(search_idx[1])]
        end
    end

    return p, u0
end


function validate(nth_param_set::Int64,p::Vector{Float64},u0::Vector{Float64})

    (p,u0) = update_param(nth_param_set,p,u0)

    if Sim.simulate!(p,u0) isa Nothing
        return Sim, true
    else
        print("Simulation failed.\nparameter_set #$nth_param_set")
        return Sim, false
    end

    return Sim
end


function write_best_fit_param(best_param_set::Int,p::Vector{Float64},u0::Vector{Float64})
    (p,u0) = update_param(best_param_set,p,u0)
    open("best_fit_param.txt","w") do f
        write(
            f,@sprintf(
                "# param set: %d\n",best_param_set
            )
        )
        write(f,"\n### Param const\n")
        for i=1:C.len_f_params
            write(
                f,@sprintf(
                    "p[C.%s] = %e\n", C.param_names[i],p[i]
                )
            )
        end
        write(f,"\n### Non-zero initial conditions\n")
        for i=1:V.len_f_vars
            if u0[i] != 0.0
                write(
                    f,@sprintf(
                        "u0[V.%s] = %e\n", V.var_names[i],u0[i]
                    )
                )
            end
        end
    end
end


function save_param_range(n_file::Int64,p::Vector{Float64},u0::Vector{Float64})
    search_idx::Tuple{Array{Int64,1},Array{Int64,1}} = search_parameter_index()
    search_param_matrix::Matrix{Float64} = zeros(length(n_file),length(search_idx[1]))

    for (k,nth_param_set) in enumerate(n_file)
        local best_indiv::Vector{Float64}
        try
            best_generation::Int64 = readdlm(
                "./fitparam/$nth_param_set/generation.dat"
            )[1,1]
            best_indiv = readdlm(
                @sprintf(
                    "./fitparam/%d/fit_param%d.dat",
                    nth_param_set, best_generation
                )
            )[:,1]
        catch
            best_indiv = zeros(length(search_idx[1])+length(search_idx[2]))
            for (i,j) in enumerate(search_idx[1])
                @inbounds best_indiv[i] = p[j]
            end
            for (i,j) in enumerate(search_idx[2])
                @inbounds best_indiv[i+length(search_idx[1])] = u0[j]
            end
        end
        search_param_matrix[k,:] = best_indiv[1:length(search_idx[1])]
    end

    # --------------------------------------------------------------------------
    # Seaborn.boxplot

    fig = figure(figsize=(8,24))
    rc("font",family = "Arial")
    rc("font",size = 12)
    rc("axes",linewidth = 1)
    gca().spines["right"].set_visible(false)
    gca().spines["top"].set_visible(false)
    gca().yaxis.set_ticks_position("left")
    gca().xaxis.set_ticks_position("bottom")

    ax = Seaborn.boxplot(
        data=search_param_matrix,
        orient="h",
        linewidth=1,
        palette="Set2"
    )

    ax.set_xlabel("Parameter value")
    ax.set_ylabel("")
    ax.set_yticklabels([C.param_names[i] for i in search_idx[1]])
    ax.set_xscale("log")

    savefig("./figure/param_range.pdf",bbox_inches="tight")
    close(fig)
end