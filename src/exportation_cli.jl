# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
"""
    exportation
AutomationPod controller function that manage regulator withing program. 

Example:

* `exportation(:tune, project_name = "...", controller_name = "...")`
"""
function exportation(args;kws...)

    if args == :tune
        results = _exportation_tune(kws)

    elseif args == :ls
        results = _exportation_ls(kws)

    elseif args == :rm
        results = _exportation_rm(kws)

    else
        @error "unrecognized argument"
        results = nothing
    end

    #to do more?

    return results
end

"""
    _exporatation_ls
List a controller for dynamical system control.
"""
function _exportation_ls(kws_)

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

    exportation_table_ls = AutomationLabsDepot.list_exportation_local_folder_db(string(project_name))
     
    # Evaluate if print is requested
    if show_all == true 
 
        print_table_ls = Array{String}(undef, size(exportation_table_ls, 1), 5)
         
        for i = 1:1:size(exportation_table_ls, 1)
            print_table_ls[i, 1] = exportation_table_ls[!, :id][i]
            print_table_ls[i, 2] = string(project_name)
            print_table_ls[i, 3] = exportation_table_ls[!, :name][i]
            print_table_ls[i, 4] = exportation_table_ls[!, :added][i]
            print_table_ls[i, 5] = exportation_table_ls[!, :size][i]
        end
 
        PrettyTables.pretty_table(
            print_table_ls;
            header = ["Id", "Project", "Exportation", "Added", "Size"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
            tf = PrettyTables.tf_matrix,
         )
        return nothing
    end
 
    return exportation_table_ls
 end

 """
    _exportation_rm
Remove a export controller or model.
"""
function _exportation_rm(kws_)

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
    if haskey(kws, :exportation_name) == true
        exportation_name = kws[:exportation_name]
    else
        @error "Unrecognized exportation name"
        return nothing
    end

    result = AutomationLabsDepot.remove_exportation_local_folder_db(
        string(project_name),
        string(exportation_name),
    )

    if result == true
            @info "$(exportation_name) from project $(project_name) is removed"
    end

    return result
end

"""
    _exportation_tune
Tune a withdrawal for dynamical system identification.
"""
function _exportation_tune(kws_)

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

    # Evaluate if project name param is present
    if haskey(kws, :controller_name) == true
        controller_name = kws[:controller_name]
    elseif haskey(kws, :model_name) == true
        model_name = kws[:model_name]
    else
        @error "Unrecognized controller or model name to export"
        return nothing
    end

    # Controller exportation
    if @isdefined(controller_name) == true

    kws_controller_tune =
    AutomationLabsDepot.load_controller_local_folder_db(
        project_name, 
        controller_name
    )

    result = AutomationLabsExportation.proceed_controller_exportation(
        controller_name,
        kws_controller_tune[:system_name],
        project_name;
        kws,
    )

        if result == true
            AutomationLabsDepot.add_exportation_local_folder_db(
                project_name, 
                controller_name
            )
        else 
            @error "Controller exportation error"
            return nothing
        end
    end

    return true
end