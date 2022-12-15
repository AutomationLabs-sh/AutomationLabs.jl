# Interact with controllers

You can interact with the `controller` to tune a Model Predictive Control from a model for dynamical system control. In addition, a large number of parameters are available to select the suitable controller to be tuned and the optimization algorithm.

## Tune a controller

To tune a controller from a model, you can use the command `:tune`:

```julia
julia> c = controller(:tune; 
                project_name = "project_1",
                model_name = "model_1",
                controller_name = "controller_1",
                mpc_controller_type = "model_predictive_control",
                mpc_programming_type = "linear",
                mpc_lower_state_constraints = mpc_lower_state_constraints,
                mpc_higher_state_constraints = mpc_higher_state_constraints,
                mpc_lower_input_constraints = mpc_lower_input_constraints,
                mpc_higher_input_constraints = mpc_higher_input_constraints,
                mpc_horizon = 6,
                mpc_sample_time = 5,
                mpc_state_reference = mpc_state_reference,
                mpc_input_reference = mpc_input_reference,       
         )    
```

where `project_name` is the name of the project, `model_name` is the model name which will be used for the controller, `controller_name` is the name of the saved controller on the database, `mpc_controller_type` is the controller, `mpc_programming_type` is the method of implementation of the model predictive control, `mpc_***_constraints` are the state and the input constraints of the controller,`mpc_horizon` is the horizon length of the controller, `mpc_sample_time` is the time sample, mpcstatereference is the state reference for the controller and `mpc_input_reference`  is the  input reference for the controller.

The `mpc_controller_type` can be a model predictive control or a economic predictive control. More information can be read on the following pages:

[Model predictive control](@raf)

[Economic model predictive control](@ref)

Furthermore, the solvers available when tuning a controller are depicted in solvers section:

[Solvers for model predictive control](@ref)

## Calculate a controller

You can calculate or compute a controller:

```julia
julia> initialization = [0.6, 0.6, 0.6, 0.6]
julia> c = controller(:calculate; 
                       initialization =  initialization, 
                       predictive_controller = c
     )
```

where `initialization` is the state initialization or measure and `predictive_controller` is the controller to calculate.

## List controllers

You can list the controllers from a project:

```julia
julia> controller(:ls, project_name = "project_1")
```

## Remove a controller

You can remove a controller from a project:

```julia
julia> controller(:rm, project_name = "project_1", controller_name = "name")
```

## Load a controller

You can load a controller from the database:

```julia
julia> controller(:load, project_name = "project1", controller_name = "controller1")
```