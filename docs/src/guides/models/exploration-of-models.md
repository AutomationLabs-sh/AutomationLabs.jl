# Exploration of models

It is possible to use the meta-heuristic algorithm to evaluate the models and optimise the type of model that reduces the cost function with `model_architecture` and `model_exploration` parameters, such as:

```julia
julia> model(:tune; 
        project_name = "name",
        model_name = "model",
        io = "io_name",
        computation_solver = "adam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "exploration_models",
        model_exploration = ["fnn", "resnet"],
    )
```

where `project_name` is the name of the related project, `model_name` is the name of the model when saving on the database, `io` is the name of input-output data, `computation_solver` is the solver selected, and `model_architecture` is the mathematical model with exploration and `model_exploration` indicates to the meta-heuristic algorithm the models to be evaluated.

Moreover, the models need to be iterable, for instance, Fnn or ResNet. More  information is readable on Parameters section:

[Parameters models](@ref)