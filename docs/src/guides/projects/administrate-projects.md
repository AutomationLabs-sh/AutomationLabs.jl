# Interact with projects

The project is the first step to work on, it will separate on different projects the raw data, the io data the models, the controllers, the dashboard and the exports. You can create as many projects as necessary.

![image-project-ls](image_project.png)

## Create a new project

You can create a new project:

```julia
julia> using AutomationPod
julia> project(:create, name = "first_project")
```

If the project name is not filled in, a random name will be provided.

## List the projects

You can list the whole projects:

```julia
julia> project(:ls)
```

## Remove a project

You can remove a project:

```julia
julia> project(:rm, name = "first_project")
```
