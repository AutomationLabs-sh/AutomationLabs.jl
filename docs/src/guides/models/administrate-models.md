# Interact with models

You can interact with the model to tune a model from io data for dynamical system identification. In addition, a large number of parameters are available to select the model to be tuned and the optimization algorithm.

![image-dynamical-system-1](model_dynamical_system (1).png)

## Tune a model

To tune and calibrate a model whether it is black box or grey box you can use the command `:tune`:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "lls",
        model_architecture = "linear", 
    )
```

where project\_name is the name of the project, model\_name is the model name when saved on the database, io is the data used to tune the model, computation\_solver is the solver used to tune the model, computation\_maximum\_time is the time allocated to tune the model and model\_architecture is the model architecture.

The blackbox models which can be selected are visible in section blackbox model’s description :

[ Blackbox models description](@ref)

During a model tuning, a hyperparameters optimization is performed with a meta\_heuristic algorithm. More information is provided in the following section:

[Hyperparameters optimization](@ref)

Furthermore, in order to measure the identification performance of a model, a cost function is used, which is presented in the section:

[Loss function](@ref)

It is possible to add extra parameters to tune a model from io data, depending on blackbox model. All the parameters are listed on parameters section:

[Parameters models](@ref)

Finally, the available solvers to tune a model are depicted in solvers section:

[Solvers](@ref)

## List models

You can list the models from a project:

```julia
julia> model(:ls, project_name = "project_1")
```

## Remove a model

You can remove a model from a dedicated project:

```julia
julia> model(:rm, project_name = "project_1", model_name = "model_name")
```