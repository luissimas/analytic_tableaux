defmodule AnalyticTableaux.CLI do
  def main(args \\ []) do
    run(args)
  end

  def run([]) do
    IO.puts("No argument provided")
  end

  def run([argument | _]) do
    case Tableaux.prove(argument) do
      {:valid, []} ->
        IO.puts("Valid argument.")

      {:invalid, counterexample} ->
        IO.puts("Invalid argument, counterexample:")
        IO.inspect(counterexample)
    end
  end
end
