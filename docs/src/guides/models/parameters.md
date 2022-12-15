# Parameters models

## `:tune`

Tune a model from io data.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `model`
* **Example**: `model(:tune, project_name = "project", model_name = "model")`

### Mandatory parameters

The following parameters are mandatory in order to tune a model from input-output data.

#### `project_name`

Set project name of the tuning machine. After computation the model will be saved in this project

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, project_name = "project")`

#### `io`

Set the input-output data for tuning a model.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, io = "io_name")`

### Optional parameters

#### Model parameters

#### `model_architecture`

Set architecture of the tuning model.

* **Default value**: fnn
* **Accepted**: string: linear, fnn, rbf, icnn, resnet, polynet, densenet, neuralnet_ode_type1, neuralnet_ode_type2, rnn, lstm, gru
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, model_architecture = "resnet")`

Please note that some architure allow iterative algorithms and hyperparameters are optimised, such as:

| Architecture        | Iterative |
| ------------------- | --------- |
| linear              | \[ ]      |
| fnn                 | \[x]      |
| rbf                 | \[x]      |
| icnn                | \[x]      |
| resnet              | \[x]      |
| polynet             | \[x]      |
| densenet            | \[x]      |
| neuralnet_ode_type1 | \[x]      |
| neulranet_ode_type2 | \[x]      |
| rnn                 | \[x]      |
| lstm                | \[x]      |
| gru                 | \[x]      |
| exploration_models   | \[x]      |

where, \[ ] not iterative and \[x] iterative.

#### model\_exploration

Set the model exploration.

* **Default value**: \["fnn", "rbf", "icnn", "resnet", "polynet", "densenet"]
* **Accepted**: vector of string: \["fnn", "rbf", "icnn", "resnet", "polynet", "densenet", "neuralnet_ode_type1", "neulranet_ode_type2", "rnn", "lstm", "gru"]
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, model_exploration = ["fnn", "resnet"])`

#### `model_sample_time`

Set the model sample time of the neulranet_ode_type2.

* **Default value**: 1.0 second
* **Accepted**: Float
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, model_sample_time = 5.0)`

#### Computation parameters

#### `computation_maximum_time`

Set the training time of the model.

* **Default value**: 15 minutes
* **Accepted**: Dates
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, maximum_time = Dates.Minute(5))`

#### `computation_solver`

Set the solver for tuning model.

* **Default value**: adam
* **Accepted**: string, adam, radam, oadam, nadam, lbfgs, oaccel, pso, lls
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, method_solver = "lbfgs")`

Please note that some solvers are specific to model, such as:

| Architecture        | adam | radam | oadam | nadam | lbfgs | oaccel | pso  | lls  |
| ------------------- | ---- | ----- | ----- | ----- | ----- | ------ | ---- | ---- |
| linear              | \[ ] | \[ ]  | \[ ]  | \[ ]  | \[ ]  | \[ ]   | \[ ] | \[X] |
| fnn                 | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| rbf                 | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| icnn                | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| resnet              | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| polynet             | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| densenet            | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| neuralnet\_ode_type1 | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| neuralnet\_ode_type2 | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| rnn                 | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| lstm                | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |
| gru                 | \[x] | \[x]  | \[x]  | \[x]  | \[x]  | \[x]   | \[x] | \[ ] |

where, \[ ] depicts no supported solvers and \[x] depicts supported solvers.

#### `computation_processor`

Set the processor used during computation.

* **Default value**: cpu_1
* **Accepted**: String, cpu_1, cpu_threads, cpu_processes
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, computation_processor = "cpu_threads")`

#### `computation_verbosity`

Set the therminal verbosity during computation.

* **Default value**: 0
* **Accepted**: 0 (no information), 1 (fragmented information) or greather than 1 (full information)
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, computation_verbosity = 5)`

#### Neural networks parameters

#### `neuralnet_activation_function`

Activation function for neural networks.

* **Default value**: relu
* **Accepted**: String: relu, sigmoid, swish, tanh
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_activation_function = "relu")`

#### `neuralnet_minimum_epochs`

Minimum epochs hyperparameter value.

* **Default value**: 50
* **Accepted**: integer and lower than `neuralnet_maximum_epochs`
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_minimum_epochs = 50)`

#### `neuralnet_maximum_epochs`

Maximum epochs hyperparameter value.

* **Default value**: 500
* **Accepted**: integer and higher than `neuralnet_minimum_epochs`
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_maximum_epochs = 500)`

#### `neuralnet_minimum_layers`

Minimum hidden layers hyperparameter value.

* **Default value**: 1
* **Accepted**: integer and lower than `neuralnet_maximum_layers`
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_minimum_layers = 1)`

#### `neuralnet_maximum_layers`

Maximum hidden layers hyperparameter value.

* **Default value**: 6
* **Accepted**: integer and higher than `neuralnet_minimum_layers`
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_minimum_layers = 6)`

#### `neuralnet_minimum_neuron`

Minimum neuron hyperparameter value.

* **Default value**: 3
* **Accepted**: integer and lower than `neuralnet_maximum_neuron`
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_minimum_layers = 3)`

#### `neuralnet_maximum_neuron`

Maximum neuron hyperparameter value.

* **Default value**: 10
* **Accepted**: integer higher than `neuralnet_minimum_neuron`
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_maximum_neuron = 10)`

#### `neuralnet_batch_size`

Batch size value when training neural network.

* **Default value**: 512
* **Accepted**: 128, 256, 512, 1024, 2048
* **Method argument**: `model(:tune, ...)`
* **Example**: `model(:tune, neuralnet_batch_size = 512)`

## `:ls`

List the models that are available for a project.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `model`
* **Example**: `model(:ls; project_name = "...")`

### Mandatory parameters

The following parameters are mandatories in order to list model from a project.

#### `project_name`

Project name to list model.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `model(:ls, ...)`
* **Example**: `model(:ls, project_name = "project#1")`

## `:rm`

Remove model for a project.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `model`
* **Example**: `model(:rm, project_name = "...", name = "...")`

### Mandatory parameters

The following parameters are mandatories in order to delete model from a project.

#### `project_name`

Project name of the model to delete.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `model(:rm, ...)`
* **Example**: `model(:rm, project_name = "project1")`

#### `model_name`

Name of the model to delete.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `model(:rm, ...)`
* **Example**: `model(:rm, model_name = "model1")`

## `:stats`

Presents information about the tuning model.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `model`
* **Example**: `model(:stats, project_name = "...", model_name = "...")`

### Mandatory parameters

The following parameters are mandatories in order to provide information about the tuning model from a project.

#### `project_name`

Project name of the model.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `model(:stats, ...)`
* **Example**: `model(:stats, project_name = "project1")`

#### `model_name`

Name of the model.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `model(:stats, ...)`
* **Example**: `model(:stats, model_name = "model1")`
