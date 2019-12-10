function searchParameterIndex()::Tuple{Array{Int64,1},Array{Int64,1}}
    # constant parameter
    searchIdxConst::Vector{Int} = [
        C.V1
        C.Km1
        C.V5
        C.Km5
        C.V10
        C.Km10
        C.n10
        C.p11
        C.p12
        C.p13
        C.V14
        C.Km14
        C.V15
        C.Km15
        C.KimDUSP
        C.KexDUSP
        C.V20
        C.Km20
        C.V21
        C.Km21
        C.V24
        C.Km24
        C.V25
        C.Km25
        C.KimRSK
        C.KexRSK
        C.V27
        C.Km27
        C.V28
        C.Km28
        C.V29
        C.Km29
        C.V30
        C.Km30
        C.V31
        C.Km31
        C.n31
        C.p32
        C.p33
        C.p34
        C.V35
        C.Km35
        C.V36
        C.Km36
        C.V37
        C.Km37
        C.KimFOS
        C.KexFOS
        C.V42
        C.Km42
        C.V43
        C.Km43
        C.V44
        C.Km44
        C.p47
        C.m47
        C.p48
        C.p49
        C.m49
        C.p50
        C.p51
        C.m51
        C.V57
        C.Km57
        C.n57
        C.p58
        C.p59
        C.p60
        C.p61
        C.KimF
        C.KexF
        C.p63
        C.KF31
        C.nF31
        C.a
    ];

    # initial values
    searchIdxInit::Vector{Int} = [
        # V.(variableName)
    ];

    return searchIdxConst, searchIdxInit
end

function getSearchRegion()::Matrix{Float64}
    p::Vector{Float64} = f_params();
    u0::Vector{Float64} = initialValues();

    searchIdx::Tuple{Array{Int64,1},Array{Int64,1}} = searchParameterIndex();

    searchParam = zeros(length(searchIdx[1])+length(searchIdx[2]));
    for (i,j) in enumerate(searchIdx[1])
        @inbounds searchParam[i] = p[j];
    end
    for (i,j) in enumerate(searchIdx[2])
        @inbounds searchParam[i+length(searchIdx[1])] = u0[j];
    end

    for i in eachindex(searchParam)
        if searchParam[i] == 0.0
            error("Error: searchParam must not contain zero.\n");
        end
    end

    searchRegion::Matrix{Float64} = zeros(2,length(p)+length(u0));

    #=
    # Default: 0.1 ~ 10x
    for (i,j) in enumerate(searchIdx[1])
        searchRegion[1,j] = searchParam[i]*0.1;  # lower bound
        searchRegion[2,j] = searchParam[i]*10.0;  # upper bound
    end

    # Default: 0.5 ~ 2x
    for (i,j) in enumerate(searchIdx[2])
        searchRegion[1,j+length(p)] = searchParam[i+length(searchIdx[1])]*0.5;  # lower bound
        searchRegion[2,j+length(p)] = searchParam[i+length(searchIdx[1])]*2.0;  # upper bound
    end
    =#

    # searchRegion[:,(C or V).paramName] = [lowerBound,upperBound]

    searchRegion[:,C.V1] = [7.33e-2,6.60e-01];
    searchRegion[:,C.Km1] = [1.83e+2,8.50e+2];
    searchRegion[:,C.V5] = [6.48e-3,7.20e+1];
    searchRegion[:,C.Km5] = [6.00e-1,1.60e+04];
    searchRegion[:,C.V10] = [exp(-10),exp(10)];
    searchRegion[:,C.Km10] = [exp(-10),exp(10)];
    searchRegion[:,C.n10] = [1.00,4.00];
    searchRegion[:,C.p11] = [8.30e-13,1.44e-2];
    searchRegion[:,C.p12] = [8.00e-8,5.17e-2];
    searchRegion[:,C.p13] = [1.38e-7,4.84e-1];
    searchRegion[:,C.V14] = [4.77e-3,4.77e+1];
    searchRegion[:,C.Km14] = [2.00e+2,2.00e+6];
    searchRegion[:,C.V15] = [exp(-10),exp(10)];
    searchRegion[:,C.Km15] = [exp(-10),exp(10)];
    searchRegion[:,C.KimDUSP] = [2.20e-4,5.50e-1];
    searchRegion[:,C.KexDUSP] = [2.60e-4,6.50e-1];
    searchRegion[:,C.V20] = [4.77e-3,4.77e+1];
    searchRegion[:,C.Km20] = [2.00e+2,2.00e+6];
    searchRegion[:,C.V21] = [exp(-10),exp(10)];
    searchRegion[:,C.Km21] = [exp(-10),exp(10)];
    searchRegion[:,C.V24] = [4.77e-2,4.77e+0];
    searchRegion[:,C.Km24] = [2.00e+3,2.00e+5];
    searchRegion[:,C.V25] = [exp(-10),exp(10)];
    searchRegion[:,C.Km25] = [exp(-10),exp(10)];
    searchRegion[:,C.KimRSK] = [2.20e-4,5.50e-1];
    searchRegion[:,C.KexRSK] = [2.60e-4,6.50e-1];
    searchRegion[:,C.V27] = [exp(-10),exp(10)];
    searchRegion[:,C.Km27] = [1.00e+2,1.00e+4];
    searchRegion[:,C.V28] = [exp(-10),exp(10)];
    searchRegion[:,C.Km28] = [exp(-10),exp(10)];
    searchRegion[:,C.V29] = [4.77e-2,4.77e+0];
    searchRegion[:,C.Km29] = [2.93e+3,2.93e+5];
    searchRegion[:,C.V30] = [exp(-10),exp(10)];
    searchRegion[:,C.Km30] = [exp(-10),exp(10)];
    searchRegion[:,C.V31] = [exp(-10),exp(10)];
    searchRegion[:,C.Km31] = [exp(-10),exp(10)];
    searchRegion[:,C.n31] = [1.00,4.00];
    searchRegion[:,C.p32] = [8.30e-13,1.44e-2];
    searchRegion[:,C.p33] = [8.00e-8,5.17e-2];
    searchRegion[:,C.p34] = [1.38e-7,4.84e-1];
    searchRegion[:,C.V35] = [4.77e-3,4.77e+1];
    searchRegion[:,C.Km35] = [2.00e+2,2.00e+6];
    searchRegion[:,C.V36] = [exp(-10),exp(10)];
    searchRegion[:,C.Km36] = [1.00e+2,1.00e+4];
    searchRegion[:,C.V37] = [exp(-10),exp(10)];
    searchRegion[:,C.Km37] = [exp(-10),exp(10)];
    searchRegion[:,C.KimFOS] = [2.20e-4,5.50e-1];
    searchRegion[:,C.KexFOS] = [2.60e-4,6.50e-1];
    searchRegion[:,C.V42] = [4.77e-3,4.77e+1];
    searchRegion[:,C.Km42] = [2.00e+2,2.00e+6];
    searchRegion[:,C.V43] = [exp(-10),exp(10)];
    searchRegion[:,C.Km43] = [1.00e+2,1.00e+4];
    searchRegion[:,C.V44] = [exp(-10),exp(10)];
    searchRegion[:,C.Km44] = [exp(-10),exp(10)];
    searchRegion[:,C.p47] = [1.45e-4,1.45e+0];
    searchRegion[:,C.m47] = [6.00e-3,6.00e+1];
    searchRegion[:,C.p48] = [2.70e-3,2.70e+1];
    searchRegion[:,C.p49] = [5.00e-5,5.00e-1];
    searchRegion[:,C.m49] = [5.00e-3,5.00e+1];
    searchRegion[:,C.p50] = [3.00e-3,3.00e+1];
    searchRegion[:,C.p51] = [exp(-10),exp(10)];
    searchRegion[:,C.m51] = [exp(-10),exp(10)];
    searchRegion[:,C.V57] = [exp(-10),exp(10)];
    searchRegion[:,C.Km57] = [exp(-10),exp(10)];
    searchRegion[:,C.n57] = [1.00,4.00];
    searchRegion[:,C.p58] = [8.30e-13,1.44e-2];
    searchRegion[:,C.p59] = [8.00e-8,5.17e-2];
    searchRegion[:,C.p60] = [1.38e-7,4.84e-1];
    searchRegion[:,C.p61] = [exp(-10),exp(10)];
    searchRegion[:,C.KimF] = [2.20e-4,5.50e-1];
    searchRegion[:,C.KexF] = [2.60e-4,6.50e-1];
    searchRegion[:,C.p63] = [exp(-10),exp(10)];
    searchRegion[:,C.KF31] = [exp(-10),exp(10)];
    searchRegion[:,C.nF31] = [1.00,4.00];
    searchRegion[:,C.a] = [1.00e+2,5.00e+2];

    searchRegion = lin2log!(searchIdx,searchRegion,length(p),length(searchParam));

    return searchRegion

end


function lin2log!(
    searchIdx::Tuple{Array{Int64,1},Array{Int64,1}},
    searchRegion::Matrix{Float64},
    nParamConst::Int,
    nSearchParam::Int
    )::Matrix{Float64}

    for i=1:size(searchRegion,2)
        if minimum(searchRegion[:,i]) < 0.0
            if i <= nParamConst
                error(@sprintf("`C.%s` searchRegion[lb,ub] must be positive.\n",C.param_names[i]));
            else
                error(@sprintf("`V.%s` searchRegion[lb,ub] must be positive.\n",V.var_names[i-nParamConst]));
            end
        elseif minimum(searchRegion[:,i]) == 0.0 && maximum(searchRegion[:,i]) != 0.0
            if i <= nParamConst
                error(@sprintf("`C.%s` lower_bound must be larger than 0.\n",C.param_names[i]));
            else
                error(@sprintf("`V.%s` lower_bound must be larger than 0.\n",V.var_names[i-nParamConst]));
            end
        elseif searchRegion[2,i] - searchRegion[1,i] < 0.0
            if i <= nParamConst
                error(@sprintf("`C.%s` lower_bound < upper_bound\n",C.param_names[i]));
            else
                error(@sprintf("`V.%s` lower_bound < upper_bound\n",V.var_names[i-nParamConst]));
            end
        end
    end

    nonZeroIdx::Vector{Int} = [];
    for i=1:size(searchRegion,2)
        if searchRegion[:,i] != [0.0,0.0]
            push!(nonZeroIdx,i);
        end
    end
    difference::Vector{Int} = collect(
        symdiff(
            Set(nonZeroIdx),
            Set(append!(searchIdx[1],nParamConst .+ searchIdx[2]))
        )
    );

    if length(difference) > 0
        for (i,j) in enumerate(difference)
            if j <= nParamConst
                print(@sprintf("`C.%s`\n",C.param_names[Int(j)]));
            else
                print(@sprintf("`V.%s`\n",V.var_names[Int(j)-nParamConst]));
            end
        end
        error("Set these searchParams in both searchIdxInit and searchRegion.");
    end

    searchRegion = searchRegion[:,nonZeroIdx];

    return log10.(searchRegion)
end