# Solvers for model predictive control

The solvers available to calculate a controller and the solver selection depends on whether the controller is linear, non-linear or linear with integer numbers. If you do not specify a solver, it will automatically assign the appropriate solver.

## Solver for linear controller

### Operator splitting solver for quadratic program (OSQP)

OSQP can solve the linear model predictive control. In order to use OSQP solver, the parameter `mpc_solver` must be filled in, such as:

```julia
julia> c = controller(:tune; 
                project_name = "QTP_test",
                model_name = "model_qtp_nonlinear",
                controller_name = "linear_controller",
                mpc_controller_type = "model_preditive_control",
                mpc_programming_type = "linear",
                mpc_lower_state_constraints = mpc_lower_statie_constraints,
                mpc_higher_state_constraints = mpc_higher_state_constraints,
                mpc_lower_input_constraints = mpc_lower_input_constraints,
                mpc_higher_input_constraints = mpc_higher_input_constraints,
                mpc_horizon = 6,
                mpc_sample_time = 5,
                mpc_state_reference = mpc_state_reference,
                mpc_input_reference = mpc_input_reference,   
                mpc_solver = "osqp",
            ) 
```

where `project_name` is the related project, `model_name` is the name used for tuning the controller, `mpc_controller_type` is the related control, `mpc programming_type` is the implementation method, `mpc_lower_state_constraints` is the state constraints, `mpc_higher_sate_constraints` is the state constraints, `mpc_lower_input_constraints` is the input control constraints, `mpc_higher_input_constraints` is the input control constraints, `mpc_horizon` is the horizon length, `mpc_sample_time` is the time between two samples, `mpc_state_reference` is the state reference,  `mpc_input_reference` is the input reference related to the model predictive control and `mpc_solver` is the parameter for solver selection.

## Solver for non linear controller

### interior-point  (Ipopt)

Ipopt can solve the non linear model predictive control. In order to use Ipopt solver, the parameter `mpc_solver` must be filled in, such as:

```julia
julia> c = controller(:tune; 
                project_name = "QTP_test",
                model_name = "model_qtp_nonlinear",
                controller_name = "linear_controller",
                mpc_controller_type = "model_predictive_control",
                mpc_programming_type = "non_linear",
                mpc_lower_state_constraints = mpc_lower_statie_constraints,
                mpc_higher_state_constraints = mpc_higher_state_constraints,
                mpc_lower_input_constraints = mpc_lower_input_constraints,
                mpc_higher_input_constraints = mpc_higher_input_constraints,
                mpc_horizon = 6,
                mpc_sample_time = 5,
                mpc_state_reference = mpc_state_reference,
                mpc_input_reference = mpc_input_reference,   
                mpc_solver = "ipopt",
            ) 
```

where `project_name` is the related project, `model_name` is the name used for tuning the controller, `mpc_controller_type` is the related control, `mpc programming_type` is the implementation method, `mpc_lower_state_constraints` is the state constraints, `mpc_higher_sate_constraints` is the state constraints, `mpc_lower_input_constraints` is the input control constraints, `mpc_higher_input_constraints` is the input control constraints, `mpc_horizon` is the horizon length, `mpc_sample_time` is the time between two samples, `mpc_state_reference` is the state reference,  `mpc_input_reference` is the input reference related to the model predictive control and `mpc_solver` is the parameter for solver selection.

## Solver for mixed integer linear controller

### Solving Integer programs and constraint programs (SCIP)

SCIP can solve the non linear model predictive control. In order to use SCIP solver, the parameter `mpc_solver` must be filled in, such as:

```julia
julia> c = controller(:tune; 
                project_name = "QTP_test",
                model_name = "model_qtp_nonlinear",
                controller_name = "linear_controller",
                mpc_controller_type = "model_predictive_control",
                mpc_programming_type = "mixed_linear",
                mpc_lower_state_constraints = mpc_lower_statie_constraints,
                mpc_higher_state_constraints = mpc_higher_state_constraints,
                mpc_lower_input_constraints = mpc_lower_input_constraints,
                mpc_higher_input_constraints = mpc_higher_input_constraints,
                mpc_horizon = 6,
                mpc_sample_time = 5,
                mpc_state_reference = mpc_state_reference,
                mpc_input_reference = mpc_input_reference,   
                mpc_solver = "scip",
            ) 
```

where `project_name` is the related project, `model_name` is the name used for tuning the controller, `mpc_controller_type` is the related control, `mpc programming_type` is the implementation method, `mpc_lower_state_constraints` is the state constraints, `mpc_higher_sate_constraints` is the state constraints, `mpc_lower_input_constraints` is the input control constraints, `mpc_higher_input_constraints` is the input control constraints, `mpc_horizon` is the horizon length, `mpc_sample_time` is the time between two samples, `mpc_state_reference` is the state reference,  `mpc_input_reference` is the input reference related to the model predictive control and `mpc_solver` is the parameter for solver selection.

## References

\[1] Stellato, B., Banjac, G., Goulart, P., Bemporad, A., & Boyd, S. (2020). OSQP: An operator splitting solver for quadratic programs. _Mathematical Programming Computation_, _12_(4), 637-672.

\[2] Wächter, A., & Biegler, L. T. (2006). On the implementation of an interior-point filter line-search algorithm for large-scale nonlinear programming. _Mathematical programming_, _106_(1), 25-57.

\[3] Vigerske, S., & Gleixner, A. (2018). SCIP: Global optimization of mixed-integer nonlinear programs in a branch-and-cut framework. _Optimization Methods and Software_, _33_(3), 563-593.