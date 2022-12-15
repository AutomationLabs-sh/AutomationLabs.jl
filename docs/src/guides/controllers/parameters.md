# Parameters

## `:tune`

Tune a controller from a model.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `controller`
* **Example**: `controller(:tune, project_name = "project1", model_name = "model1", )`

### Mandatory parameters

The following parameters are mandatories in order to tune a controller from a model.

#### `project_name`

Set project name of the tuning controller.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, project_name = "project1")`

#### `model_name`

Set model name of the tuning controller.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, model_name = "model1")`

#### `mpc_lower_state_constraints`

Set the lower model predictive contraints of the state.

* **Default value**: nothing
* **Accepted**: vector
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_lower_state_constraints = [0.2 , 0.2])`

#### `mpc_higher_state_constraints`

Set the higher model predictive contraints of the state.

* **Default value**: nothing
* **Accepted**: vector
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_higher_state_constraints = [2 , 2])`

#### `mpc_lower_input_constraints`

Set the lower model predictive contraints of the input.

* **Default value**: nothing
* **Accepted**: vector
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_lower_input_constraints = [1 , 1])`

#### `mpc_higher_input_constraints`

Set the lower model predictive contraints of the input.

* **Default value**: nothing
* **Accepted**: vector
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_lower_input_constraints = [10 , 10])`

#### `mpc_horizon`

Set the horizon length of the model predictive control or economic model predictive control.

* **Default value**: nothing
* **Accepted**: integer
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_horizon = 25)`

#### `mpc_state_reference`

Set the state reference of the model predictive control. The references are also used as a linearized point when a linear controller is requested from a non linear model.

* **Default value**: nothing
* **Accepted**: vector
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_state_reference = [0.5, 0.5])`

#### `mpc_input_reference`

Set the input reference of the model predictive control. The references are also used as a linearized point when a linear controller is requested from a non linear model.

* **Default value**: nothing
* **Accepted**: vector
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_input_reference = [1, 1])`

#### `mpc_sample_time`

Set the sample time of the model predictive control or economic model predictive control.

* **Default value**: nothing
* **Accepted**: integer
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_sample_time = 5)`

### Optional parameters

#### `controller_name`

Set the controller name on the database to create.

* **Default value**: random
* **Accepted**: string
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, controller_name = "controller1")`

#### `mpc_controller_type`

Set the model predictive control or the economic model predictive control.

* **Default value**: "model_predictive_control"
* **Accepted**: string, model_predictive_control , economic_model_predictive_control
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_controller_type = "model_predictive_control")`

#### `mpc_programming_type`

Set the model predictive control implementation type.

* **Default value**: NonLinear
* **Accepted**: string, Linear, NonLinear, MixedLinear
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_programming_type = "non_linear")`

#### `mpc_solver`

Set the solver of the model predictive control or economic model predictive control.

* **Default value**: automatic according to the model and `mpc_programming_type`
* **Accepted**: string, osqp, scip, mosek, ipopt, highs
* **Method argument**: `controller(:tune, ...)`
* **Example**: `controller(:tune, mpc_solver = "ipopt")`

## `:calculate`

Calculate (or compute) a controller with initialization state.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `controller`
* **Example**: `controller(:calculate, initialization = [0.5])`

### `Mandatory parameters`

#### `initialization`

Set the state initialization (or measure) of the controller to calculate.

* **Default value**: nothing
* **Accepted**: vector
* **Method argument**: `controller(:calculate, ...)`
* **Example**: `controller(:calculate, initialization = [0.3, 0.3])`

## `:load`

Load a controller from the database in order to calculate the controller.

### `Mandatory parameters`

#### `project_name`

Set the project name of the controller to load.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `controller(:load, ...)`
* **Example**: `controller(:load, project_name = "project1")`

#### `controller_name`

Set the controller name of the controller to load.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `controller(:load, ...)`
* **Example**: `controller(:load, controller_name = "controller1")`

## `:ls`

List the controller that are available.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `controller`
* **Example**: `controller(:ls, project_name = "project1")`

### `Mandatory parameters`

#### `project_name`

Set the project name of the controller to list.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `controller(:ls, ...)`
* **Example**: `controller(:ls, project_name = "project1")`

## `:rm`

Remove a controller from a project.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `controller`
* **Example**: `controller(:rm, project_name = "project1")`

### `Mandatory parameters`

#### `project_name`

Set the project name of the controller to remove.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `controller(:rm, ...)`
* **Example**: `controller(:rm, project_name = "project1")`

#### `controller_name`

Set the controller name of the controller to remove.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `controller(:remove, ...)`
* **Example**: `controller(:rm, controller_name = "controller1")`
