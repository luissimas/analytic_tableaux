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

  @spec add_expansion(BinTree.t(), map(), boolean()) :: BinTree.t()
  def add_expansion(tree, expansion, source_found \\ false)

  def add_expansion(nil, _, _), do: nil

  def add_expansion(
        %{left: nil, right: nil} = tree,
        %{type: :branch, result: [left, right], source: source_id},
        source_found
      ) do
    source_found = source_id == tree.value.nid || source_found

    if source_found do
      BinTree.add_branch_node(tree, %BinTree{
        value: nil,
        left: %BinTree{value: left},
        right: %BinTree{value: right}
      })
    else
      tree
    end
  end

  def add_expansion(
        %{left: left, right: right} = tree,
        %{type: :branch, source: source_id} = expansion,
        source_found
      ) do
    source_found = source_id == tree.value.nid || source_found

    %BinTree{
      tree
      | left: add_expansion(left, expansion, source_found),
        right: add_expansion(right, expansion, source_found)
    }
  end

  def add_expansion(
        %{left: nil, right: nil} = tree,
        %{type: :linear, result: list, source: source_id},
        source_found
      ) do
    source_found = source_id == tree.value.nid || source_found

    if source_found do
      BinTree.add_linear_node(tree, BinTree.from_list(list))
    else
      tree
    end
  end

  def add_expansion(
        %{left: left, right: right} = tree,
        %{type: :linear, source: source_id} = expansion,
        source_found
      ) do
    source_found = source_id == tree.value.nid || source_found

    %BinTree{
      tree
      | left: add_expansion(left, expansion, source_found),
        right: add_expansion(right, expansion, source_found)
    }
  end

  def add_expansion(tree, %{type: :atom}, _), do: tree
end
