# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
"""
    controller
AutomationPod controller function that manage regulator withing program. 

Example:

* `controller(:tune, project_name = "...")`
"""
function controller(args; kws...)

    if args == :tune
        results = _controller_tune(kws)
        return results

    elseif args == :ls
        results = _controller_ls(kws)
        return results

    elseif args == :rm
        results = _controller_rm(kws)
        return results

    elseif args == :calculate
        result = _controller_calculate(kws)
        return result

    elseif args == :load
        predictive_controller = _controller_load(kws)
        return predictive_controller

    elseif args == :retrieve
        results = _controller_retrieve(kws)
        return results

    else
        # Wrong arguments
        @error "unrecognized argument"
    end

    #to do more?

    return nothing
end

"""
    _controller_ls
List a controller for dynamical system control.
"""
function _controller_ls(kws_)

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

    controller_table_ls =
        AutomationLabsDepot.list_controller_local_folder_db(string(project_name))

    # Evaluate if print is requested
    if show_all == true 

        print_table_ls = Array{String}(undef, size(controller_table_ls, 1), 5)

        for i = 1:1:size(controller_table_ls, 1)
            print_table_ls[i, 1] = controller_table_ls[!, :id][i]
            print_table_ls[i, 2] = string(project_name)
            print_table_ls[i, 3] = controller_table_ls[!, :name][i]
            print_table_ls[i, 4] = controller_table_ls[!, :added][i]
            print_table_ls[i, 5] = controller_table_ls[!, :size][i]
        end

        PrettyTables.pretty_table(
            print_table_ls;
            header = ["Id", "Project", "Controllers", "Added", "Size"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
            tf = PrettyTables.tf_matrix,
        )
        return nothing
    end

    return controller_table_ls
end

"""
    _controller_rm
Remove a controller from the database.
"""
function _controller_rm(kws_)

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

    # Evaluation if name controller is present in kws
    if haskey(kws, :controller_name) == true
        controller_name = kws[:controller_name]
    else
        @error "unrecognized controller name"
        return nothing
    end

    result = AutomationLabsDepot.remove_controller_local_folder_db(
        string(project_name),
        string(controller_name),
    )
   
    if result == true
        @info "$(controller_name) from project $(project_name) is removed"
    end

    return result
end

#NamedTuple default parameters definition
const DEFAULT_PARAMETERS_CONTROLLER = (
    mpc_model = "non_linear",
    mpc_x_lower_constraints = [-Inf],
    mpc_x_upper_constraints = [Inf],
    mpc_u_lower_constraints = [-Inf],
    mpc_u_upper_constraints = [Inf],
    mpc_maximum_time = Dates.Minute(5),
    mpc_solver = "ipopt",
    mpc_terminal_ingredient = false,
    mpc_cost_function = "quadratic",
)

"""
    _controller_tune
Tune a controller for dynamical system control.
"""
function _controller_tune(kws_)

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

    # Get the system name
    if haskey(kws, :system_name) == true
        system_name = kws[:system_name]
    else
        @error "Unrecognized system name"
        return nothing
    end

    system_loaded = AutomationLabsDepot.load_system_local_folder_db(string(project_name), string(system_name))

    # Get the controller name choosen by user or get a randomized name
    if haskey(kws, :controller_name) == true
        controller_name = kws[:controller_name]
    else
        @warn "Unrecognized controller name"
        controller_name = Random.randstring('a':'z', 6)
        @info "Random controller name is provided: $(controller_name)"
    end

    # Get mpc implementation type
    if haskey(kws, :mpc_controller_type) == true
        mpc_controller_type = kws[:mpc_controller_type]
    else
        @warn "Unrecognized mpc controller type"
        mpc_controller_type = "model_predictive_control"
        @info "Model predictive control implementation method is: $(mpc_controller_type)"
    end

    # Get the mpc horizon and sample time 
    if haskey(kws, :mpc_horizon) == true
        mpc_horizon = kws[:mpc_horizon]
    else
        @error "Unrecognized controller horizon"
        return nothing
    end

    if haskey(kws, :mpc_sample_time) == true
        mpc_sample_time = kws[:mpc_sample_time]
    else
        @error "Unrecognized controller sample time"
        return nothing
    end

    # Get the sate and input reference or the linearization pint for empc
    if haskey(kws, :mpc_state_reference) == true
        mpc_state_reference = kws[:mpc_state_reference]
    else
        @error "Unrecognized controller state references"
        return nothing
    end

    if haskey(kws, :mpc_input_reference) == true
        mpc_input_reference = kws[:mpc_input_reference]
    else
        @error "Unrecognized controller input references"
        return nothing
    end

    # Tune the controller on AutomationLabsModelPredictiveControl
    predictive_controller = AutomationLabsModelPredictiveControl.proceed_controller(
        system_loaded,
        mpc_controller_type,
        mpc_horizon,
        mpc_sample_time,
        mpc_state_reference,
        mpc_input_reference;
        kws,
    )

    # Save the controller jump on memory
    append!(
        controller_loaded_memory,
        [controller_name, kws, predictive_controller]
    )

    # Save the controller on database and hardrive
    if @isdefined(predictive_controller) == true
        #save the model into folder and database
        results_db = AutomationLabsDepot.add_controller_local_folder_db(
            predictive_controller,
            kws,
            project_name,
            controller_name,
        )
    end

    return results_db
end

"""
    _controller_tune_without_save
Tune a controller for dynamical system control when load a last tune controller.
"""
function _controller_tune_without_save(kws_)

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

    # Get the system name
    if haskey(kws, :system_name) == true
        system_name = kws[:system_name]
    else
        @error "Unrecognized system name"
        return nothing
    end
    
    system_loaded = AutomationLabsDepot.load_system_local_folder_db(string(project_name), string(system_name))
    

    # Get the model name
    if haskey(kws, :model_name) == true
        model_name = kws[:model_name]
    else
        @error "Unrecognized model name"
        return nothing
    end

    # Get the controller name choosen by user or get a randomized name
    if haskey(kws, :controller_name) == true
        controller_name = kws[:controller_name]
    else
        @warn "Unrecognized controller name"
        controller_name = Random.randstring('a':'z', 6)
        @info "Random controller name is provided: $(controller_name)"
    end

    # Get mpc implementation type
    if haskey(kws, :mpc_controller_type) == true
        mpc_controller_type = kws[:mpc_controller_type]
    else
        @warn "Unrecognized mpc controller type"
        mpc_controller_type = "model_predictive_control"
        @info "Model predictive control implementation method is: $(mpc_controller_type)"
    end

    # Get the mpc horizon and sample time 
    if haskey(kws, :mpc_horizon) == true
        mpc_horizon = kws[:mpc_horizon]
    else
        @error "Unrecognized controller horizon"
        return nothing
    end

    if haskey(kws, :mpc_sample_time) == true
        mpc_sample_time = kws[:mpc_sample_time]
    else
        @error "Unrecognized controller sample time"
        return nothing
    end

    # Get the sate and input reference or the linearization pint for empc
    if haskey(kws, :mpc_state_reference) == true
        mpc_state_reference = kws[:mpc_state_reference]
    else
        @error "Unrecognized controller state references"
        return nothing
    end

    if haskey(kws, :mpc_input_reference) == true
        mpc_input_reference = kws[:mpc_input_reference]
    else
        @error "Unrecognized controller input references"
        return nothing
    end

    # Tune the controller on AutomationLabsModelPredictiveControl
    predictive_controller = AutomationLabsModelPredictiveControl.proceed_controller(
        system_loaded,
        mpc_controller_type,
        mpc_horizon,
        mpc_sample_time,
        mpc_state_reference,
        mpc_input_reference;
        kws,
    )

    # Save the controller jump on memory
    append!(
        controller_loaded_memory,
        [controller_name, kws, predictive_controller]
    )

    #Add verification on flag

    return true
end

"""
    _controller_calculate
Calculate a controller for dynamical system control.
"""
function _controller_calculate(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    if haskey(kws, :initialization) == true
        initialization = kws[:initialization]
    else
        @error "Unrecognized controller initialization"
        return nothing
    end

    # Get the controller name choosen by user or get a randomized name
    if haskey(kws, :controller_name) == true
        controller_name = kws[:controller_name]
    else
        @error "Unrecognized controller name"
        return nothing
    end

    #Evaluate if the controller is in the controller_loadded_memory
    global index_controller = findfirst(isequal(controller_name), AutomationLabs.controller_loaded_memory)

   if index_controller == nothing
        # Load the controller 
        _controller_load(kws)
        index_controller = findfirst(isequal(controller_name), AutomationLabs.controller_loaded_memory)
   end

    # Add the initialization for the predictive controller
    AutomationLabsModelPredictiveControl.update_initialization!(
        AutomationLabs.controller_loaded_memory[index_controller + 2],
        initialization,
    )

    # Calculate the opimization x and u
    AutomationLabsModelPredictiveControl.calculate!(AutomationLabs.controller_loaded_memory[index_controller + 2])

    return AutomationLabs.controller_loaded_memory[index_controller + 2]
end

"""
    _controller_load
Load a controller for dynamical system control.
"""
function _controller_load(kws_)

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

    # Get the controller name
    if haskey(kws, :controller_name) == true
        controller_name = kws[:controller_name]
    else
        @error "Unrecognized controller name"
        return nothing
    end

    kws_tune =
        AutomationLabsDepot.load_controller_local_folder_db(project_name, controller_name)

    predictive_controller = _controller_tune_without_save(kws_tune["controller_parameters"])

    return predictive_controller
end

"""
    _controller_retrieve
Retrieve a controller for dynamical system control.
"""
function _controller_retrieve(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    # Get the controller name choosen by user or get a randomized name
    if haskey(kws, :controller_name) == true
        controller_name = kws[:controller_name]
    else
        @error "Unrecognized controller name"
        return nothing
    end

    #Evaluate if the controller is in the controller_loadded_memory
    index_controller = findfirst(isequal(controller_name), AutomationLabs.controller_loaded_memory)

    if index_controller == nothing
        @error "Controller is not loaded and computed"
        return nothing
   end

   return AutomationLabs.controller_loaded_memory[index_controller+2].computation_results

end