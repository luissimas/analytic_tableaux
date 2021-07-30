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

  def expand(tree, to_apply \\ [])

  def expand(tree, []), do: tree

  def expand(tree, to_apply) do
    [formula | rest] =
      to_apply
      |> Enum.sort_by(
        &Rules.get_type/1,
        &Rules.compare_operators(&1, &2)
      )

    expansion = Rules.apply_rule(formula)

    case expansion.type do
      :atom ->
        tree
        |> expand(List.flatten(rest))

      _ ->
        tree
        |> add_expansion(expansion)
        |> expand(List.flatten(rest ++ [expansion.result]))
    end
  end

  defp add_expansion(tree, %{type: :branch} = expansion) do
    [left, right] = expansion.result

    expansion_node = %BinTree{
      value: nil,
      left: BinTree.create_node(left),
      right: BinTree.create_node(right)
    }

    BinTree.add_branch_node(tree, expansion_node)
  end

  defp add_expansion(tree, %{type: :linear} = expansion) do
    BinTree.add_linear_node(tree, BinTree.from_list(expansion.result))
  end

  defp add_expansion(tree, %{type: :atom} = expansion) do
    BinTree.add_linear_node(tree, BinTree.create_node(expansion.result))
  end
end
