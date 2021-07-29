defmodule Tableaux do
  @moduledoc """
    Analytic tableaux algoritm implementation, for details on the algoritm itself see:
  https://en.wikipedia.org/wiki/Method_of_analytic_tableaux
  """

  def solve(input) do
    tree = input |> Parser.parse() |> BinTree.from_list()

    tree
    |> expand_linear()
  end

  defp expand_linear(tree, acc \\ [])

  defp expand_linear(%{left: nil} = tree, acc) do
    new_tree =
      (acc ++ [tree.value])
      |> Rules.apply_linear_rules()
      |> BinTree.from_list()

    %BinTree{tree | left: new_tree}
  end

  defp expand_linear(tree, acc) do
    %BinTree{tree | left: expand_linear(tree.left, acc ++ [tree.value])}
  end
end
