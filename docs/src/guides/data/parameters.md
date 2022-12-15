# Parameters

## `:add`

Add data for dynamical system identification.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `data`
* **Example**: `data(:add)`

### Mandatory parameters

#### `path`

Set path on local disk of the data to add.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:add, ...)`
* **Example**: `data(:add, path = "/home/...")`

#### `project_name`

Set project name of the data to add.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:add, ...)`
* **Example**: `data(:add, project_name = "name")`

#### `name`

Set the name of the data to add.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:add, ...)`
* **Example**: `data(:add, name = "name")`

## `:io`

Set a input output data pair for model identification.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `data`
* **Example**: `data(:io, ...)`

### Mandatory parameters

#### `inputs_data_name`

Set the raw input data.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, inputs_data_name = "raw_input")`

#### `outputs_data_name`

Set the raw output data.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, outputs_data_name = "raw_output")`

#### `project_name`

Set project to create the io data.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, project_name = "project")`

#### `data_name`

Set the iodata to be referenced by the database and the filepath.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, data_name = "io_data")`

### Optional parameters

#### `n_delay`

Set delay for deep time delay.

* **Default value**: 1
* **Accepted**: Integer
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, n_delay = 1)`

#### **`n_sequence`**

Set the required sequence length for a recurrent neural networks model. The n\_sequence is a suite of samples.&#x20;

* **Default value**: nothing
* **Accepted**: Integer
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, n_sequence = 64)`

#### `normalisation`

Set data normalisation for data from 0 to 1.

* **Default value**: false
* **Accepted**: Boolean
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, normalisation = false)`

#### `data_lower_input`

Set a lower limit on input data.

* **Default value**: \[-Inf]
* **Accepted**: vector
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, data_lower_input = [0.2])`

#### `data_upper_input`

Set a upper limit on input data

* **Default value**: \[Inf]
* **Accepted**: vector
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, data_upper_limit = [1.2])`

#### `data_lower_output`

Set a lower limit on output data.

* **Default value**: \[-Inf]
* **Accepted**: Vector
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, data_lower_output = [0.2])`

#### `data_upper_output`

Set a upper limit on output data.

* **Default value**: \[Inf]
* **Accepted**: Vector
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, data_upper_limit = [1.2])`

#### `data_type`

Set type on data.

* **Default value**: Float64
* **Accepted**: Float32 or Float64
* **Method argument**: `data(:io, ...)`
* **Example**: `data(:io, data_type = Float64)`

## `:ls`

List the data that are available.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `data`
* **Example**: `data(:ls; project_name = "...")`

### Mandatory parameters

#### `project_name`

Set project name of the data to list.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:ls, ...)`
* **Example**: `data(:ls, project_name = "name")`

## `:rm`

Remove data `from` a project.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `data`
* **Example**: `data(:rm, project_name = "name")`

### Mandatory parameters

#### `project_name`

Set project name of the data to delete.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:rm, ...)`
* **Example**: `data(:rm, project_name = "name")`

#### `name`

Set name of the data to delete.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `data(:rm, ...)`
* **Example**: `data(:rm, name = "name")`
