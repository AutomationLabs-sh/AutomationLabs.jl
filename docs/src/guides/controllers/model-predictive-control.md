# Model predictive control

The Model Predictive Control (MPC) is an advanced control method, which is able to control multi-inputs and multi-output systems. It uses an internal model of the process to be controlled, enabling it to predict its behavior over a certain horizon length, and to optimize its control inputs on this basis. The implementation of an MPC control involves the real-time resolution of an optimization problem on the basis of a criterion defining the control objectives, such as setpoint tracking. The foundation of this control method is attributed to J. Richalet, in 1978 \[1].

## Formulation

The model predictive control formulation envolves a quadratic cost function with constraints \[2], such as:

```math
\text{min}~ \sum_{i=1}^N \tilde{x}_i^TQ \tilde{x}_i + \tilde{u}_i^T R \tilde{u}_i
```

```math
\text{subject to:} \\ \hat{x}_{i+1} = f(\hat{x}_i, u_i) \\ \tilde{x}_i = \hat{x}_i -  x_i^r \\ \tilde{u}_i = u_i - u_i^r \\ \hat{x}_0 =  \bar{x}(t_k) \\ x_{min} \leq \hat{x}_i \leq x_{max} \\ u_{min} \leq u_i \leq u_{max}
```

where $$\hat{x}$$ is the state prediction according the model of the dynamical system, $$u$$is the input control, $$\tilde{x}$$ is the state deviation from the state reference, $$\tilde{u}$$ is the input control deviation from the input control reference, $$\bar{x}$$ is the state initialization, $$x_{min}$$ and $$x_{max}$$ is the state constraints and umin and umax is the input control constraints.

## Terminal ingredients

For the moment, the terminal ingredients cannot be added.

## References

\[1] Richalet, J., Rault, A., Testud, J. L., & Papon, J. (1978). Model predictive heuristic control: Applications to industrial processes. _Automatica_, _14_(5), 413-428.

\[2] Mayne, D. Q., Rawlings, J. B., Rao, C. V., & Scokaert, P. O. (2000). Constrained model predictive control: Stability and optimality. _Automatica_, _36_(6), 789-814.