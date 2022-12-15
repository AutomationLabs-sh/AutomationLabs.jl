# Hyperparameters optimization

The hyperparameters include the parameters of the neural network. The hyperparameters considered are: the number of neurons, the number of layers, the activation function, the batch size, the number of epochs, the optimizer used. They have an influence on the learning time of the network and the final performance of the model \[1]. Get a good hyperparameters before learning is tricky if not impossible, as well as testing all the possibilities. So, the hyperparameters can be optimized with a cost function, such as:

* A selection of hyperparameters is performed;
* A neural network with the hyperparameters obtained in the previous step is trained;
* The network is trained;
* When the training is completed, the performance of the network is evaluated with the dataset;

At the beginning, the hyperparameters are chosen arbitrarily. Then as the iterations progress, their influence on the model performance of the black box model is taken into account and the cost function is reduced. The optimization problem with the hyperparameters of the neural network is non-convex and non-derivable and the use of metaheuristic algorithms is required \[1]. When tuning a model, the hyperparameters range value can be configured, such as:

```julia
julia> model(:tune; 
        project_name = "name",
        model_name = "model",
        io = "io_name",
        computation_solver = "adam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
        neuralnet_minimum_epochs = 500,
        neuralnet_maximum_epochs = 1000,
    )
```

where `project_name` the name of the related project, `model_name` the name of the model when saving on the database, `io` the name of input-output data, `computation_solver` the solver selected, `computation_maximum_time` the maximum time of the tune with Fnn and hyperparameters optimization, and `model_architecture` the mathematical model selected. Furthermore, the epochs hyperparameter range value are chosen with `neuralnet_minimum_epochs` and `neuralnet_maximum_epochs,` as a result the algorithm can choose epochs from 500 to 1000. The hyperparameters which can be modified are:

* `neuralnet_minimum_epochs;`
* `neuralnet_maximum_epochs;`
* `neuralnet_minimum_layers;`
* `neuralnet_minimum_neuron;`
* `neuralnet_maximum_neuron;`

Moreover, note that the model need to be iterable, for instance, the Fnn or ResNet. More hyperparameters information is readable on Parameters section:

[Parameters models](@ref)

#### Reference

\[1] Blaud, P. (2022). _Pilotage distribué de systèmes multi-énergies en réseau_ (Doctoral dissertation, Ecole nationale supérieure Mines-Télécom Atlantique).
