# Parameters

## `:rawdata`

Plot from rawdata.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `dash`
* **Example**: `dash(:rawdata)`

### Mandatory parameters

#### `data_name`

Set data name of the data to plot.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:rawdata, ...)`
* **Example**: `dash(:rawdata, data_name = "name")`

#### `project_name`

Set project name of the data to plot.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:rawdata, ...)`
* **Example**: `dash(:rawdata, project_name = "name")`

#### `dash_name`

Set name of the dasboard.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:rawdata, ...)`
* **Example**: `dash(:rawdata, dash_name = "name")`

#### `recipe`

Set the recipe of the dasboard.

* **Default value**: temporal
* **Accepted**: temporal, box
* **Method argument**: `dash(:rawdata, ...)`
* **Example**: `dash(:rawdata, recipe = "temporal")`

## `:iodata`

Plot from iodata.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `dash`
* **Example**: `dash(:iodata)`

### Mandatory parameters

#### `data_name`

Set data name of the data to plot.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:iodata, ...)`
* **Example**: `dash(:iodata, data_name = "name")`

#### `project_name`

Set project name of the data to plot.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:iodata, ...)`
* **Example**: `dash(:iodata, project_name = "name")`

#### `dash_name`

Set name of the dasboard.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:iodata, ...)`
* **Example**: `dash(:iodata, dash_name = "name")`

#### `recipe`

Set the recipe of the dasboard.

* **Default value**: temporal
* **Accepted**: temporal, box
* **Method argument**: `dash(:iodata, ...)`
* **Example**: `dash(:iodata, recipe = "temporal")`

## `:ls`

List dashboards from a dedicated project.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `dash`
* **Example**: `dash(:ls)`

### Mandatory parameters

#### `project_name`

Set project name of the dashboards to list.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:ls, ...)`
* **Example**: `dash(:ls, project_name = "name")`

## `:rm`

Plot from iodata.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `dash`
* **Example**: `dash(:iodata)`

### Mandatory parameters

#### `dash_name`

Set the name of the dashboard to remove.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:rm, ...)`
* **Example**: `dash(:rm, dash_name = "name")`

#### `project_name`

Set project name of the dashboard to remove.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `dash(:rm, ...)`
* **Example**: `dash(:rm, project_name = "name")`
