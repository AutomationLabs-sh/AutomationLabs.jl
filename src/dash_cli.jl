# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
"""
    dash
AutomationPod dash function that manage dashboards withing program. It is possible to plot data (temporal and boxplot), model optimization results.

Example:

* `dash(:data, project_name = "...")`
"""
function dash(args; kws...)

    if args == :rawdata
        figure = _dash_rawdata(kws)
        return figure

    elseif args == :iodata
        figure = _dash_iodata(kws)
        return figure

    elseif args == :model
        figure = _dash_model(kws)
        return figure 

    elseif args == :ls
        result = _dash_ls(kws)
        return result

    elseif args == :rm
        result = _dash_rm(kws)

    else
        # Wrong arguments
        @error "Unrecognized argument"
        result = nothing
    end

    #to do more?

    return nothing
end

"""
    _dash_rawdata
Create a dashboards of raw data for dynamical system identification.
"""
function _dash_rawdata(kws_)

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

    # Get the data name
    if haskey(kws, :data_name) == true
        data_name = kws[:data_name]
    else
        @error "Unrecognized data name"
        return nothing
    end

    # Get the plot recipe temporal, boxplot, kde (kernel density estimation)
    if haskey(kws, :recipe) == true
        recipe = kws[:recipe]
    else
        @error "Unrecognized recipe for the dashboard"
        return nothing
    end

    # Get the dashboard name choosen by the user, if not provided te name is randomized
    if haskey(kws, :dash_name) == true
        dash_name = kws[:dash_name]
    else
        @warn "Unrecognized dashboard name"
        dash_name = Random.randstring('a':'z', 6)
        @info "Random dashboard name is provided: $(dash_name)"
    end

    figure = AutomationLabsDepot.add_rawdata_dashboard_local_folder_db(
        string(project_name),
        string(data_name),
        string(recipe),
        string(dash_name);
        kws,
    )
    return nothing
end

"""
    _dash_iodata
Create a dashboards of io data for dynamical system identification.
"""
function _dash_iodata(kws_)

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

    # Get the data name
    if haskey(kws, :data_name) == true
        data_name = kws[:data_name]
    else
        @error "Unrecognized data name"
        return nothing
    end

    # Get the plot recipe temporal, boxplot, kde (kernel density estimation)
    if haskey(kws, :recipe) == true
        recipe = kws[:recipe]
    else
        @error "Unrecognized recipe for the dashboard"
        return nothing
    end

    # Get the dashboard name choosen by the user, if not provided te name is randomized
    if haskey(kws, :dash_name) == true
        dash_name = kws[:dash_name]
    else
        @warn "Unrecognized dashboard name"
        dash_name = Random.randstring('a':'z', 6)
        @info "Random dashboard name is provided: $(dash_name)"
    end

    figure = AutomationLabsDepot.add_iodata_dashboard_local_folder_db(
        string(project_name),
        string(data_name),
        string(recipe),
        string(dash_name);
        kws,
    )

    return nothing
end

"""
    _dash_model
Create a dashboards of model optimization tuning for dynamical system identification.
"""
function _dash_model(kws_)

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

    # Get the model name
    if haskey(kws, :model_name) == true
        model_name = kws[:model_name]
    else
        @error "Unrecognized model name"
        return nothing
    end

    # 
end

# dash ls
"""
    _dash_ls
List dashboards available.
"""
function _dash_ls(kws_)

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

    # Get user selection for ploting cli 
    show_all = get(kws, :show_all, false)

    dash_table_ls = AutomationLabsDepot.list_dash_local_folder_db(string(project_name))
    
    # Evaluate if print is requested
    if show_all == true 

        print_table_ls = Array{String}(undef, size(dash_table_ls, 1), 5)

        for i = 1:1:size(dash_table_ls, 1)
            print_table_ls[i, 1] = dash_table_ls[!, :id][i]
            print_table_ls[i, 2] = string(project_name)
            print_table_ls[i, 3] = dash_table_ls[!, :name][i]
            print_table_ls[i, 4] = dash_table_ls[!, :added][i]
            print_table_ls[i, 5] = dash_table_ls[!, :size][i]
        end

        PrettyTables.pretty_table(
            print_table_ls;
            header = ["Id", "Project", "Dashboards", "Added", "Size"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
            tf = PrettyTables.tf_matrix,
        )
        return nothing
    end

    return dash_table_ls
end

# dash rm
"""
    _dash_rm
Delete a data dash file.
"""
function _dash_rm(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    # Evaluate if project name is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "Unrecognized project name"
        return nothing
    end

    # Evaluate if dash name is present
    if haskey(kws, :dash_name) == true
        dash_name_rm = kws[:dash_name]
    else
        @error "Unrecognized dashboard name to delete"
        return nothing
    end

    result = AutomationLabsDepot.remove_dash_local_folder_db(
        string(project_name),
        string(dash_name_rm),
    )
        if result == true
            @info "$(dash_name_rm) from project $(project_name) is removed"
        end

    return result
end
