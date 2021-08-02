defmodule Tableaux do
  @moduledoc """
    Analytic tableaux algoritm implementation, for details on the algoritm itself see:
  https://en.wikipedia.org/wiki/Method_of_analytic_tableaux
  """

  def solve(input) do
    sequent = Parser.parse(input)

    tree = BinTree.from_list(sequent)

    expand(tree, sequent)
  end

  def expand(tree, to_apply, applied \\ [])

  def expand(tree, [], _), do: tree

  def expand(tree, to_apply, applied) do
    [formula | rest] =
      to_apply
      |> Enum.sort_by(
        &Rules.get_type/1,
        &Rules.compare_operators(&1, &2)
      )

    expansion = Rules.apply_rule(formula, Enum.count(to_apply) + Enum.count(applied))

    case expansion.type do
      :atom ->
        tree
        |> expand(List.flatten(rest), applied ++ [formula])

      _ ->
        tree
        |> add_expansion(expansion)
        |> expand(List.flatten(rest ++ [expansion.result]), applied ++ [formula])
    end
  end

  @spec add_expansion(BinTree.t(), map()) :: BinTree.t()
  def add_expansion(tree, %{type: :branch, result: [left, right]}) do
    BinTree.add_branch_node(tree, %BinTree{
      value: nil,
      left: %BinTree{value: left},
      right: %BinTree{value: right}
    })
  end

  def add_expansion(tree, %{type: :linear, result: list}) do
    BinTree.add_linear_node(tree, BinTree.from_list(list))
  end

  def add_expansion(tree, %{type: :atom, result: atom}) do
    BinTree.add_linear_node(tree, %BinTree{value: atom})
  end
end
