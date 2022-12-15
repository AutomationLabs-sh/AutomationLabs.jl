using Documenter
using AutomationLabs

makedocs(
    sitename = "AutomationLabs.jl",
    format = Documenter.HTML(),
    modules = [AutomationLabs],
    pages = [
	"Home" => ["index.md"],
	"Installation" => ["installation/installation.md"],
    	"Quick start" => [
    		"Introduction" => "quick_start/introductory.md",
    		"Manage your first data" => "quick_start/manage-your-first-data.md",
			"Tune your first model" => "quick_start/tune-your-first-model.md",
			"Tune your first controller" => "quick_start/tune-your-first-controller.md"],
		"Guides" => [
			"Administrate projects" => [
										"Interact with projects" => "guides/projects/administrate-projects.md",
										"Parameters" => "guides/projects/parameters.md"],
			"Administrate data" => [
										"Interact with data" => "guides/data/administrate-data.md",
										"Parameters" => "guides/data/parameters.md"],
			"Administrate models" => [
										"Interact with models" => "guides/models/administrate-models.md",
										"Blackbox models description" => "guides/models/blackbox-models-description.md",
										"Hyperparameters optimization" => "guides/models/hyperparameters-optimization.md",
										"Exploration of models" => "guides/models/exploration-of-models.md",
										"Loss functions" => "guides/models/loss-function.md",
										"Solvers" => "guides/models/solvers.md",
										"Manage the electronic circuit" => "guides/models/manage-the-electronic-circuit.md",
										"Parameters" => "guides/models/parameters.md"],
			"Administrate controllers" => [
										 "Interact with controllers" => "guides/controllers/administrate-controllers.md",
										 "Model predictive control" => "guides/controllers/model-predictive-control.md",
										 "Economic model predictive control" => "guides/controllers/economic-model-predictive-control.md",
										 "Solvers" => "guides/controllers/solvers.md",
										 "Parameters" => "guides/controllers/parameters.md"],
			"Administrate dashboards" => [
										 "Interact with dashboards" => "guides/dashboards/administrate-dashboards.md",
										 "Parameters" => "guides/dashboards/parameters.md"],
				],
		"Reference" => [
				"CLI" => "reference/cli.md",
		],
		"Collaboration" => [
				"How to contribute" => "collaboration/how-to-contribute.md"
		],
		"Roadmap" => [
				"Planned for v2.0.x" => "roadmap/planned-for-v0.2.x.md"
		],
	]
)

