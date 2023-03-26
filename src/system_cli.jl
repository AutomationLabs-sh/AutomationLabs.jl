# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
"""
    system
AutomationLabs system function that manage system withing program. It is possible to create, list and remove systems.

Example:

* `system(:ls)`
"""
function system(args; kws...)

    if args == :tune
        _system_tune(kws)

    elseif args == :ls
        rslt = _system_ls(kws)
        return rslt

    elseif args == :rm
        _system_rm(kws)

    elseif args == :load
       sys = _system_load(kws)
       return sys

    elseif args == :stats 
        _system_stats(kws)

    else
        # Wrong arguments
        @error "Unrecognized argument"
    end

    #to do more?
    return nothing
end


"""
    _system_ls
List a system for dynamical system control.
"""
function _system_ls(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    # Evaluate if project name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "unrecognized project name"
        return nothing
    end

    # Get user selection for ploting cli 
    show_all = get(kws, :show_all, false)

    system_table_ls =
        AutomationLabsDepot.list_system_local_folder_db(string(project_name))

    # Evaluate if print is requested
    if show_all == true 

        print_table_ls = Array{String}(undef, size(system_table_ls, 1), 5)
        
        for i = 1:1:size(system_table_ls, 1)
            print_table_ls[i, 1] = system_table_ls[!, :id][i]
            print_table_ls[i, 2] = string(project_name)
            print_table_ls[i, 3] = system_table_ls[!, :name][i]
            print_table_ls[i, 4] = system_table_ls[!, :added][i]
            print_table_ls[i, 5] = system_table_ls[!, :size][i]
        end

        PrettyTables.pretty_table(
            print_table_ls;
            header = ["Id", "Project", "Systems", "Added", "Size"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
            tf = PrettyTables.tf_matrix,
        )

        return nothing 
    end

    return system_table_ls
end

"""
    _system_rm
Remove a system from the database.
"""
function _system_rm(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    # Evaluate if name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "unrecognized project name"
        return nothing
    end

    # Evaluation if name system is present in kws
    if haskey(kws, :system_name) == true
        system_name = kws[:system_name]
    else
        @error "unrecognized system name"
        return nothing
    end

    result = AutomationLabsDepot.remove_system_local_folder_db(
            string(project_name),
            string(system_name),
    )
    if result == true
        @info "$(system_name) from project $(project_name) is removed"
    end
    return nothing
end

"""
    _system_stats
Statistics about a system.
"""
function _system_stats(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    # Evaluate if name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "Unrecognized project name"
        return nothing
    end

    # Evaluation if system model is present in kws
    if haskey(kws, :system_name) == true
        system_name = kws[:system_name]
    else
        @error "Unrecognized system name"
        return nothing
    end


    stats_ls_system = AutomationLabsDepot.stats_system_local_folder_db(
        string(project_name),
        string(system_name),
    )

    print_table_ls = Array{Any}(undef, 1, 8)

    print_table_ls[1, 1] = system_name
    print_table_ls[1, 2] = stats_ls_system[1, 1]
    print_table_ls[1, 3] = stats_ls_system[2, 1]
    print_table_ls[1, 4] = stats_ls_system[3, 1]

    PrettyTables.pretty_table(
        print_table_ls;
        header = [
            "System",
            "Type",
            "Input constraint",
            "State constraint",
        ],
        alignment = :l,
        border_crayon = PrettyTables.crayon"blue",
    )

    return nothing
end

"""
    _system_tune
Tune a system for dynamical system control.
"""
function _system_tune(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    # Evaluate if project name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "Unrecognized project name"
        return nothing
    end

    # Get model name
    if haskey(kws, :model_name) == true
        model_name = kws[:model_name]

        model_method = "discrete"
        model_origin = "identification"

    else
        @error "Unrecognized model name"
        return nothing
    end

    # Get the system name choosen by user or get a randomized name
    if haskey(kws, :system_name) == true
        system_name = kws[:system_name]
    else
        @warn "Unrecognized system name"
        system_name = Random.randstring('a':'z', 6)
        @info "Random system name is provided: $(system_name)"
    end

    # Get the input constraint 
#=    if haskey(kws, :input_constraint) == true
        input_constraint = kws[:input_constraint]
    end

    # Get the state constraint 
    if haskey(kws, :state_constraint) == true
        state_constraint = kws[:state_constraint]
    end=#

    # Load the model machine mlj from hard drive and database 
    global model_loaded = AutomationLabsDepot.load_model_local_folder_db(
        string(project_name),
        string(model_name),
    )

    # Evaluation of linear user model
    if isdefined(model_loaded, :A) == true
        #It is a linear model 
        if  occursin("Discrete", string(typeof(model_loaded))) == true
            variation = "discrete"
        end

        if  occursin("Continuous", string(typeof(model_loaded))) == true
            variation = "continuous"
        end

        system = AutomationLabsSystems.proceed_system(model_loaded.A, model_loaded.B, model_loaded.nbr_state, model_loaded.nbr_input, variation; kws) 
        AutomationLabsDepot.add_system_local_folder_db(system, project_name, system_name)
    end

    # Evaluation of non linear user model
    if isdefined(model_loaded, :f) == true
        # It is a non linear model 
        if  occursin("Discrete", string(typeof(model_loaded))) == true
            variation = "discrete"
        end

        if  occursin("Continuous", string(typeof(model_loaded))) == true
            variation = "continuous"
        end

        system = AutomationLabsSystems.proceed_system(model_loaded.f, model_loaded.nbr_input, variation; kws) 
        AutomationLabsDepot.add_system_local_folder_db(system, project_name, system_name)
    end

    return nothing
end
