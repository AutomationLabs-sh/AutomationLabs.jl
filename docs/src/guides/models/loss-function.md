# Loss function

The loss function implemented is the Mean Absolute Error (MAE) \[1]:

```math
MAE = \frac{1}{N_b} \sum_{n=1}^ {N_b} |x_n - \hat{x} _n|
```

where,$$N_b$$ is the total number of samples, $$x$$ is the tageted sample and $$\hat{x}$$ is the output of the model.

#### Reference

\[1] Blaud, P. (2022). _Pilotage distribué de systèmes multi-énergies en réseau_ (Doctoral dissertation, Ecole nationale supérieure Mines-Télécom Atlantique).
