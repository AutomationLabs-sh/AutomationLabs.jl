# Interact with dashboards

## Create a dashboard from raw data

To create a dashboard from raw data you can use the dash command, such as:

```julia
julia> dash(:rawdata, 
    project_name = "project", 
    data_name = "data", 
    recipe = "temporal",
    dash_name = "dash_temporal",
)
```

where `project_name` is the name of the project,`data_name` is the data name, `recipe` is the dashboard type, `dash_name` is dash board name when saved on the database.

## Create a dashboard from io data

To create a dashboard from io data you can use the dash command, such as:

```julia
julia> dash(:iodata, 
        project_name = "project", 
        data_name = "data", 
        recipe = "temporal",
        dash_name = "dash_temporal",
    )
```

where `project_name` is the name of the project,`data_name` is the data name, `recipe` is the dashboard type, `dash_name` is dash board name when saved on the database.

## List dashboards

You can list the dashboards from a project:

```julia
julia> dash(:ls, project_name = "project")
```

## Remove a dashboard

You can remove a dashboard from a project:

```julia
julia> dash(:rm, project_name = "project", dash_name = "dash")
```

