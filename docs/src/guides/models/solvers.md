# Solvers

There are different solvers to tune the model and minimize the loss function.

## Linear programming

### Linear least squares (lls)

The lls used the least square approximation of a linear function to data, and it can be used to tune the linear model. The selection of LLS is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "lls",
        model_architecture = "linear", 
    )
```

## Non linear programming

### Backpropagation through time

The gradient-based back-propagation algorithm \[1] \[2] allows iteratively tunes weights and bias of neurons and bias \[3]:

```math
W = W + \Delta W
```

```math
b + b + \Delta b
```

where W is the weighting vector, ∆W is the increment vector, b is the bias and ∆b is the increment vector. The increment vectors are:

```math
\Delta W = \eta \frac{\partial L}{\partial W}
```

```math
\Delta b = \eta \frac{\partial L}{\partial b}
```

with η the learning rate and L a loss function. The learning rate is sensitive in regard to stability and training performance with respect to identification performance. Large value derives in lack of robustness in convergence and small value derives in lack of identification accuracy. In order to boost neural network training performance, we selected stochastic gradient descent Adam optimizer \[4] and derivative Radam \[5], Nadam \[6], Oadam \[7]. They allow to fine tune the learning rate during training.

#### Adam

The selection of Adam is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "adam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
    )
```

#### Radam

The selection of Radam is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "radam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
    )
```

#### Nadam

The selection of Nadam is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "nadam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
    )
```

#### Oadam

The selection of Oadam is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "oadam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
    )
```

### Other non linear solvers

#### **Limited-memory Broyden Fletcher Goldfarb Shanno** (LBFGS)

The selection of LBFGS \[10] is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "lbfgs",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
    )
```

#### Objective acceleration (OACCEL)

The selection of Oaccel \[8] is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "oaccel",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
    )
```

#### Particle swarm optimization (PSO)

The selection of PSO \[9] is done by `computation_solver` parameter, such as:

```julia
julia> model(:tune; 
        project_name = "project_1",
        model_name = "model_name",
        io = "io_name",
        computation_solver = "pso",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn", 
    )
```

## References

\[1] LeCun, Y. (1985). Une procedure d'apprentissage pour reseau a seuil asymetrique. _Proceedings of Cognitiva 85_, 599-604.

\[2] Rumelhart, D. E., Hinton, G. E., & Williams, R. J. (1986). Learning representations by back-propagating errors. _nature_, _323_(6088), 533-536.

\[3] Blaud, P. C., Chevrel, P., Claveau, F., Haurant, P., & Mouraud, A. (2022). ResNet and PolyNet based identification and (MPC) control of dynamical systems: a promising way. _IEEE Access_.

\[4] Kingma, D. P., & Ba, J. (2014). Adam: A method for stochastic optimization. International Conference on Learning Representations (ICLR), San Diego, CA, USA.

\[5] Liu, L., Jiang, H., He, P., Chen, W., Liu, X., Gao, J., & Han, J. (2019). On the variance of the adaptive learning rate and beyond. International Conference on Learning Representations (ICLR), Addis Ababa, Ethiopia.

\[6] Dozat, T. (2016). Incorporating nesterov momentum into adam.

\[7] Daskalakis, C., Ilyas, A., Syrgkanis, V., & Zeng, H. (2017). Training gans with optimism. International Conference on Learning Representations (ICLR), Vancouver, BC, Canada.

\[8] Riseth, A. N. (2019). Objective acceleration for unconstrained optimization. _Numerical Linear Algebra with Applications_, _26_(1).

\[9] Bonyadi, M. R., & Michalewicz, Z. (2017). Particle swarm optimization for single objective continuous space problems: a review. _Evolutionary computation_, _25_(1), 1-54.

\[10] Liu, D. C., & Nocedal, J. (1989). On the limited memory BFGS method for large scale optimization. _Mathematical programming_, _45_(1), 503-528.

