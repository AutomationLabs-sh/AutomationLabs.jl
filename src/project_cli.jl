# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
"""
    project
AutomationPod project function that manage projects withing program. It is possible to create, list and remove projects.

Example:

* `projects(:ls)`
"""
function project(args; kws...)

    if args == :create
        rslt = _project_create(kws)

    elseif args == :ls
        rslt = _project_ls(kws)

    elseif args == :rm
        rslt = _project_rm(kws)

    else
        # Wrong arguments
        @error "Unrecognized argument"
        rslt = nothing
    end

    #to do more?

    return rslt
end

"""
    _project_create
Design an empty project for dynamical system identification.
"""
function _project_create(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    #evaluate if name param is present
    if haskey(kws, :name) == true
        project_name = kws[:name]
    else
        @warn "Unrecognized project name"
        project_name = Random.randstring('a':'z', 6)
        @info "Random project name is provided: $(project_name)"
    end

    result = AutomationLabsDepot.project_folder_create_db(string(project_name))
        
    if result == true
        @info "Project $(project_name) is created"
    end

    return result
end

"""
    _project_ls
List projects avalaible.
"""
function _project_ls(kws_)

        # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    # Get user selection for ploting cli 
    show_all = get(kws, :show_all, false)

    # Get list of projects
    project_table_ls = AutomationLabsDepot.list_project_local_folder_db()

    # Memory allocation
    data_tab = []
    dash_tab = []
    models_tab = []
    controller_tab = []
    system_tab = []
    exportation_tab = []

    # Get Data, Dash, Models, Systems, Controllers 
    for i in project_table_ls

        data_table_rawls = AutomationLabsDepot.list_rawdata_local_folder_db(string(i))
        data_table_iols = AutomationLabsDepot.list_iodata_local_folder_db(string(i))
        dash_table_ls = AutomationLabsDepot.list_dash_local_folder_db(string(i))
        model_table_ls = AutomationLabsDepot.list_model_local_folder_db(string(i))
        controller_table_ls = AutomationLabsDepot.list_controller_local_folder_db(string(i))
        system_table_ls = AutomationLabsDepot.list_system_local_folder_db(string(i))
        exportation_table_ls = AutomationLabsDepot.list_exportation_local_folder_db(string(i))

        append!(data_tab, size(data_table_iols, 1) + size(data_table_rawls, 1))
        append!(dash_tab, size(dash_table_ls, 1))
        append!(models_tab, size(model_table_ls, 1))
        append!(controller_tab, size(controller_table_ls, 1))
        append!(system_tab, size(system_table_ls, 1))
        append!(exportation_tab, size(exportation_table_ls, 1))

    end

    # Concatenate the tables
    tab = hcat(project_table_ls, data_tab, dash_tab, models_tab, system_tab, controller_tab, exportation_tab)
    
    # Evaluate if print is requested
    if show_all == true 
        # Print pretty table
        PrettyTables.pretty_table(
            tab;
            header = [ "Project", "Data", "Dashboards", "Models", "Systems", "Controllers", "Exportations" #"Dash status","Models status","Systems status" 
                        ],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
            #columns_width = [10], 
            tf = PrettyTables.tf_matrix
        )
        return nothing
    end
    
    return tab
end

"""
    _project_rm
Remove a project.
"""
function _project_rm(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    #evaluate if name param is present
    if haskey(kws, :name) == true
        project_name = kws[:name]
    else
        @error "Unrecognized macro argument"
        return nothing
    end

    result = AutomationLabsDepot.remove_project_local_folder_db(string(project_name))
    if result == true
        @info "Project $(project_name) is removed"
    end
    return result
end
