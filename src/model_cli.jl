# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
"""
    model
AutomationPod model function that manage models withing program. It is possible to tune, list and remove models.

Example:

* `model(:ls, project_name = "...")`
"""
function model(args; kws...)

    if args == :tune
        # Train a model from data
        _model_tune(kws)

    elseif args == :ls
        # List all model available in local folder
        _model_ls(kws)

    elseif args == :rm
        # Remove a tune model from local folder
        _model_rm(kws)

    elseif args == :stats
        # List information about model after tuning 
        _model_stats(kws)

    else
        # Wrong arguments
        @error "Unrecognized argument"
    end

    #to do more?

    return nothing
end

#NamedTuple default parameters definition
const DEFAULT_PARAMETERS_MODEL = (
    computation_maximum_time = Dates.Minute(15),
    computation_solver = "radam",
    model_architecture = "fnn",
)
"""
    _model_tune
Tune a model for dynamical system identification.
"""
function _model_tune(kws_)

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

    # Get the input and output data name
    if haskey(kws, :io) == true
        iodata_name = kws[:io]
    else
        @error "Unrecognized iodata name"
        return nothing
    end

    # Get the model name choosen by user or get a randomized name
    if haskey(kws, :model_name) == true
        model_name = kws[:model_name]
    else
        @warn "Unrecognized model name"
        model_name = Random.randstring('a':'z', 6)
        @info "Random model name is provided: $(model_name)"
    end

    # Evaluate if physics informed then f, trainable_paramters_init and sample time are passed
    if haskey(kws, :model_architecture) == "physics_informed"
        if haskey(kws, :f) == true
            f = kws[:f]
        else
            @error "Unrecognized mathematical function f"
            return nothing
        end

        if haskey(kws, :trainable_parameters_init) == true
            trainable_parameters_init = kws[:trainable_parameters_init]
        else
            @error "Unrecognized trainable parameters"
            return nothing
        end

        if haskey(kws, :model_sample_time) == true
            sample_time = kws[:model_sample_time]
        else
            @error "Unrecognized sample time"
            return nothing
        end
    end

    # Load the data from hard drive and database 
    train_dfin, train_dfout = AutomationLabsDepot.load_iodata_local_folder_db(
        string(project_name),
        string(iodata_name),
    )

    # Get default argument or kws if user has set parameters
    architecture =
        get(kws, :model_architecture, DEFAULT_PARAMETERS_MODEL[:model_architecture])
    solver = get(kws, :computation_solver, DEFAULT_PARAMETERS_MODEL[:computation_solver])
    maximum_time = get(
        kws,
        :computation_maximum_time,
        DEFAULT_PARAMETERS_MODEL[:computation_maximum_time],
    )

    mach_model = AutomationLabsIdentification.proceed_identification(
        train_dfin,
        train_dfout,
        solver,
        architecture,
        maximum_time;
        kws,
    )

    if @isdefined(mach_model) == true
        #save the model into folder and database
        AutomationLabsDepot.add_model_local_folder_db(mach_model, project_name, model_name)
    end

    return nothing
end

# model ls
"""
    _model_ls
List models available.
"""
function _model_ls(kws_)

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

    model_table_ls = AutomationLabsDepot.list_model_local_folder_db(string(project_name))

    if size(model_table_ls, 1) == 0
        @info "There is no model in $(project_name) folder"

    elseif size(model_table_ls, 1) != 0
        #There is at least a model in the database

        print_table_ls = Array{String}(undef, size(model_table_ls, 1), 5)
        for i = 1:1:size(model_table_ls, 1)

            print_table_ls[i, 1] = model_table_ls[!, :id][i]
            print_table_ls[i, 2] = string(project_name)
            print_table_ls[i, 3] = model_table_ls[!, :name][i]
            print_table_ls[i, 4] = model_table_ls[!, :added][i]
            print_table_ls[i, 5] = model_table_ls[!, :size][i]

        end

        PrettyTables.pretty_table(
            print_table_ls;
            header = ["Id", "Project", "Models", "Added", "Size"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
        )
    else
        @warn "Unrecognized project name"
    end

    return nothing
end

"""
    _model_rm
Remove a train model.
"""
function _model_rm(kws_)

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

    # Evaluation if name model is present in kws
    if haskey(kws, :model_name) == true
        model_name = kws[:model_name]
    else
        @error "Unrecognized model name"
        return nothing
    end

    # Remove a data from a project
    print("Do you want to remove ")
    printstyled("$(model_name) ", bold = true)
    print("from project ")
    print("$(project_name) [y/n] (y): ")
    n = readline()

    if n == "y" || n == "yes"

        result = AutomationLabsDepot.remove_model_local_folder_db(
            string(project_name),
            string(model_name),
        )
        if result == true
            @info "$(model_name) from project $(project_name) is removed"
        end

    else
        @info "$(model_name) from project $(project_name) is not removed"
    end

    return nothing

end


"""
    _model_stats
Statistics about a train model.
"""
function _model_stats(kws_)

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

    # Evaluation if name model is present in kws
    if haskey(kws, :model_name) == true
        model_name = kws[:model_name]
    else
        @error "Unrecognized model name"
        return nothing
    end


    stats_ls_best_model = AutomationLabsDepot.stats_model_local_folder_db(
        string(project_name),
        string(model_name),
    )


    print_table_ls = Array{Any}(undef, 1, 8)

    print_table_ls[1, 1] = model_name
    print_table_ls[1, 2] = stats_ls_best_model[1, 1]
    print_table_ls[1, 3] = stats_ls_best_model[2, 1][1]
    print_table_ls[1, 4] = stats_ls_best_model[3, 1]
    print_table_ls[1, 5] = stats_ls_best_model[4, 1]
    print_table_ls[1, 6] = stats_ls_best_model[5, 1]
    print_table_ls[1, 7] = stats_ls_best_model[6, 1]
    print_table_ls[1, 8] = stats_ls_best_model[7, 1]


    PrettyTables.pretty_table(
        print_table_ls;
        header = [
            "Models",
            "Iteration",
            "Loss best",
            "Architecture",
            "Neurons",
            "Layers",
            "Epochs",
            "Activation function",
        ],
        alignment = :l,
        border_crayon = PrettyTables.crayon"blue",
    )

    return nothing
end
