Benchee.run(
  %{
    "PHP1:" => fn -> ProblemGenerator.generate(1) |> Tableaux.prove() end,
    "PHP2:" => fn -> ProblemGenerator.generate(2) |> Tableaux.prove() end
  },
  memory_time: 2
)
