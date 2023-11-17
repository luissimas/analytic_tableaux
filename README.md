# Analytic Tableaux
An implementation of the [Analytic Tableaux](https://en.wikipedia.org/wiki/Method_of_analytic_tableaux) proof method.

``` elixir
iex(1)> Tableaux.prove "p->q, t |- q"
    {:invalid, [t: true, p: false]}

iex(2)> Tableaux.prove "p->q, p |- q"
    {:valid, []}
```

There is also a `ProblemGenerator` module, capable of generating of PHP logical problems. Those arguments are always valid.

``` elixir
iex(3)> ProblemGenerator.generate(:php, 2)
    "((p1_1|p1_2)&(p2_1|p2_2)&(p3_1|p3_2)) |- ((p1_1&p2_1)|(p1_1&p3_1)|(p2_1&p3_1)|(p1_2&p2_2)|(p1_2&p3_2)|(p2_2&p3_2))"

iex(4)> ProblemGenerator.generate(:php, 2) |> Tableaux.prove()
    {:valid, []}
``` 

## Generating an executable 
The project provides a executable using [escript](https://www.erlang.org/doc/man/escript.html). To generate the executable, run:

``` sh
mix escript.build
```

The generated executable receives an logical argument as the first command-line argument. For example:

``` sh
./analytic_tableaux "p->q, p |- q"
```
