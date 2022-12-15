# Parameters

## `:create`

Create a project for AutomationLabs.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `project`
* **Example**: `project(:create, name = "name_project")`

### Optional parameters

#### `name`

Set project name.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `project(:create, ...)`
* **Example**: `project(:create, name = "name_project")`

## `:ls`

List the project that are available.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `project`
* **Example**: `project(:ls)`

## `:rm`

Remove a project.

* **Default value**: nothing
* **Accepted**: nothing
* **Method argument**: `project`
* **Example**: `project(:rm, name = "name_project")`

### Mandatory parameters

#### `name`

Set project name to delete.

* **Default value**: nothing
* **Accepted**: string
* **Method argument**: `project(:rm, ...)`
* **Example**: `project(:rm, name = "name_project")`
