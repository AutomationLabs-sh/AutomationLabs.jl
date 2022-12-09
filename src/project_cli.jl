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
        _project_create(kws)

    elseif args == :ls
        _project_ls()

    elseif args == :rm
        _project_rm(kws)

    else
        # Wrong arguments
        @error "Unrecognized argument"
    end

    #to do more?

    return nothing
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

    # Add a whole project
    print("Do you want to create ")
    printstyled("$(project_name) ", bold = true)
    print("project [y/n] (y): ")
    n = readline()

    if n == "y" || n == "yes"

        result = AutomationLabsDepot.project_folder_create_db(string(project_name))
        if result == true
            @info "Project $(project_name) is created"
        end

    else
        @info "$(project_name) project is not designed"
    end

    return nothing
end

"""
    _project_ls
List projects avalaible.
"""
function _project_ls()

    project_table_ls = AutomationLabsDepot.list_project_local_folder_db()

    if size(project_table_ls, 1) == 0
        @info "There is no project in the database"

    elseif size(project_table_ls, 1) != 0

        PrettyTables.pretty_table(
            project_table_ls;
            header = ["Project"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
        )
    else
        @warn "Unrecognized project name"
    end

    return nothing
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

    # Remove a whole project
    print("Do you want to remove ")
    printstyled("$(project_name) ", bold = true)
    print("project [y/n] (y): ")
    n = readline()

    if n == "y" || n == "yes"

        result = AutomationLabsDepot.remove_project_local_folder_db(string(project_name))
        if result == true
            @info "Project $(project_name) is removed"
        end
    else
        @info "$(project_name) project is not removed"
    end

    return nothing
end
