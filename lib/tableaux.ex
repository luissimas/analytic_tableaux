defmodule Tableaux do
  @moduledoc """
    Analytic tableaux algoritm implementation, for details on the algoritm itself see:
  https://en.wikipedia.org/wiki/Method_of_analytic_tableaux
  """

  def solve(input) do
    formulas = Parser.parse(input)

    IO.puts("Linear rules: ")
    IO.inspect(apply_linear_rules(formulas))

    IO.puts("Branching rules: ")
    IO.inspect(apply_branch_rules(formulas))

    :ok
  end

  defp apply_linear_rules(list) do
    list
    |> Enum.filter(&Rules.is_linear?/1)
  end

  defp apply_branch_rules(list) do
    list
    |> Enum.filter(&Rules.is_branch?/1)
  end
end
