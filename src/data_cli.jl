# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
"""
    data
AutomationPod data function that manage data withing program. It is possible to add, list and remove data.

Example:

* `data(:ls, project_name = "...")`
"""
function data(args; kws...)

    if args == :add
        _data_add(kws)

    elseif args == :ls
        _data_ls(kws)

    elseif args == :lsio
        _data_lsio(kws)

    elseif args == :lsraw
        _data_lsraw(kws)

    elseif args == :rmraw
        _data_rmraw(kws)

    elseif args == :rmio
        _data_rmio(kws)

    elseif args == :io
        _data_io(kws)

    else
        # Wrong arguments
        @error "Unrecognized argument"
    end

    #to do more?

    return nothing
end

# data add
"""
    _data_add
Add dynamical system data table to the working folder. The working folder stores all the data used for identification.
"""
function _data_add(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    #evaluate if name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "Unrecognized project name"
        return nothing
    end

    if haskey(kws, :path) == true
        data_path = kws[:path]
    else
        @error "Unrecognized path"
        return nothing
    end

    if haskey(kws, :name) == true
        data_name = kws[:name]
    else
        @warn "Unrecognized name for the data"

        data_name = Random.randstring('a':'z', 6)
        @info "Random data name is provided: $(data_name)"
    end

    if haskey(kws, :project_name) == true || haskey(kws, :path) == true

        try
            AutomationLabsDepot.add_rawdata_local_folder_db(
                string(project_name),
                string(data_path),
                string(data_name),
            )
            @info "$(data_name) from project $(project_name) is added"

        catch
            @warn "Unrecognized project or data path or data name argument"
        end
    end

    return nothing
end

# data ls
"""
    _data_ls
"""
#import AutomationLabsDepot: list_data_local_folder
function _data_ls(kws_)

    _data_lsraw(kws_)
    _data_lsio(kws_)

    return nothing
end

# data ls
"""
    _data_lsio
"""
#import AutomationLabsDepot: list_data_local_folder
function _data_lsio(kws_)

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

    # Get the data inside project folder
    data_table_ls = AutomationLabsDepot.list_iodata_local_folder_db(string(project_name))

    if size(data_table_ls, 1) == 0
        @info "There are no iodata in $(project_name)"
    elseif size(data_table_ls, 1) != 0

        print_table_ls = Array{String}(undef, size(data_table_ls, 1), 5)
        for i = 1:1:size(data_table_ls, 1)
            print_table_ls[i, 1] = data_table_ls[!, :id][i]
            print_table_ls[i, 2] = string(project_name)
            print_table_ls[i, 3] = data_table_ls[!, :name][i]
            print_table_ls[i, 4] = data_table_ls[!, :added][i]
            print_table_ls[i, 5] = data_table_ls[!, :size][i]
        end

        PrettyTables.pretty_table(
            print_table_ls;
            header = ["Id", "Project", "Io data", "Added", "Size"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
        )
    else
        @warn "Unrecognized project name"
    end
    return nothing
end

# data lsraw
"""
    _data_lsraw
"""
#import AutomationLabsDepot: list_data_local_folder
function _data_lsraw(kws_)

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

    # Get the data inside project folder
    data_table_ls = AutomationLabsDepot.list_rawdata_local_folder_db(string(project_name))

    if size(data_table_ls, 1) == 0
        @info "There are no rawdata in $(project_name)"

    elseif size(data_table_ls, 1) != 0

        print_table_ls = Array{String}(undef, size(data_table_ls, 1), 5)# size(data_table_ls, 2) + 1)
        for i = 1:1:size(data_table_ls, 1)
            print_table_ls[i, 1] = data_table_ls[!, :id][i]
            print_table_ls[i, 2] = string(project_name)
            print_table_ls[i, 3] = data_table_ls[!, :name][i]
            print_table_ls[i, 4] = data_table_ls[!, :added][i]
            print_table_ls[i, 5] = data_table_ls[!, :size][i]
        end

        PrettyTables.pretty_table(
            print_table_ls;
            header = ["Id", "Project", "Raw data", "Added", "Size"],
            alignment = :l,
            border_crayon = PrettyTables.crayon"blue",
        )
    else
        @warn "Unrecognized project name"
    end
    return nothing
end

# data rm
"""
    _data_rmraw
Delete a data table file.
"""
function _data_rmraw(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    #evaluate if name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "Unrecognized project name"
        return nothing
    end

    if haskey(kws, :data_name) == true
        data_name_rm = kws[:data_name]
    else
        @error "Unrecognized data to delete"
        return nothing
    end

    # Remove a data from a project
    print("Do you want to remove ")
    printstyled("$(data_name_rm) ", bold = true)
    print("from project ")
    print("$(project_name) [y/n] (y): ")
    n = readline()

    if n == "y" || n == "yes"


        result = AutomationLabsDepot.remove_rawdata_local_folder_db(
            string(project_name),
            string(data_name_rm),
        )
        if result == true
            @info "$(data_name_rm) from project $(project_name) is removed"
        end
    else
        @info "$(data_name_rm) from project $(project_name) is not removed"
    end
    return nothing
end

# data rm
"""
    _data_rmio
Delete a data table file.
"""
function _data_rmio(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    #evaluate if name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "Unrecognized project name"
        return nothing
    end

    if haskey(kws, :data_name) == true
        data_name_rm = kws[:data_name]
    else
        @error "Unrecognized data to delete"
        return nothing
    end

    # Remove a data from a project
    print("Do you want to remove ")
    printstyled("$(data_name_rm) ", bold = true)
    print("from project ")
    print("$(project_name) [y/n] (y): ")
    n = readline()

    if n == "y" || n == "yes"

        result = AutomationLabsDepot.remove_iodata_local_folder_db(
            string(project_name),
            string(data_name_rm),
        )
        if result == true
            @info "$(data_name_rm) from project $(project_name) is removed"
        end


    else
        @info "$(data_name_rm) from project $(project_name) is not removed"
    end
    return nothing
end

const DEFAULT_PARAMETERS_IODATA = (
    n_delay = 1,
    normalisation = false,
    data_lower_input = [-Inf], #Est ce que data est nécessaire? non enlever car deja data 
    data_upper_input = [Inf],
    data_lower_output = [-Inf],
    data_upper_output = [Inf],
    data_type = Float64,
    n_amount = 1,
)

# data io
"""
    _data_io
Create a iodata table file.
"""
#import AutomationLabsDepot.add_controller_local_folder_db

function _data_io(kws_)

    # Get argument kws
    dict_kws = Dict{Symbol,Any}(kws_)
    kws = get(dict_kws, :kws, kws_)

    #evaluate if name param is present
    if haskey(kws, :project_name) == true
        project_name = kws[:project_name]
    else
        @error "Unrecognized project name"
        return nothing
    end

    #evaluate if dfin is present
    if haskey(kws, :inputs_data_name) == true
        inputs_data_name = kws[:inputs_data_name]
    else
        @error "Unrecognized inputs data name"
        return nothing
    end

    #Evaluate if dfout is present
    if haskey(kws, :outputs_data_name) == true
        outputs_data_name = kws[:outputs_data_name]
    else
        @error "Unrecognized outputs data name"
        return nothing
    end

    # merge data
    print("Do you want to create the trainning data from ")
    printstyled("$(inputs_data_name) ", bold = true)
    print("and ")
    printstyled("$(outputs_data_name) ", bold = true)
    print("from project ")
    print("$(project_name) [y/n] (y): ")
    n = readline()

    if n == "y" || n == "yes"

        # Get default argument or kws
        n_delay = get(dict_kws, :n_delay, DEFAULT_PARAMETERS_IODATA[:n_delay])
        normalisation =
            get(dict_kws, :normalisation, DEFAULT_PARAMETERS_IODATA[:normalisation])
        data_lower_input =
            get(dict_kws, :data_lower_input, DEFAULT_PARAMETERS_IODATA[:data_lower_input])
        data_upper_input =
            get(dict_kws, :data_upper_input, DEFAULT_PARAMETERS_IODATA[:data_upper_input])
        data_lower_output =
            get(dict_kws, :data_lower_output, DEFAULT_PARAMETERS_IODATA[:data_lower_output])
        data_upper_output =
            get(dict_kws, :data_upper_output, DEFAULT_PARAMETERS_IODATA[:data_upper_output])
        data_type = get(dict_kws, :data_type, DEFAULT_PARAMETERS_IODATA[:data_type])

        # Get the name of the iodata created 
        if haskey(kws, :data_name) == true
            data_name = kws[:data_name]
        else
            data_name = Random.randstring('a':'z', 6)
            @info "Iodata name is provided: $(data_name)"
        end

        result = AutomationLabsDepot.iodata_local_folder_db(
            inputs_data_name,
            outputs_data_name,
            project_name,
            data_name,
            n_delay,
            normalisation,
            data_lower_input,
            data_upper_input,
            data_lower_output,
            data_upper_output,
            data_type,
        )

        if result == true
            @info "Iodata $(data_name) from project $(project_name) is created"
        end
    else
        @info "Iodata from project $(project_name) is not created"
    end
    return nothing
end
