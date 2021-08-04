defmodule Tableaux do
  @moduledoc """
    Analytic tableaux algoritm implementation, for details on the algoritm itself see:
  https://en.wikipedia.org/wiki/Method_of_analytic_tableaux
  """

  def solve(input) do
    sequent = Parser.parse(input)

    tree = BinTree.from_list(sequent)

    expand(tree, sequent) |> branch_closed?()
  end

  defp expand(tree, to_apply, applied \\ [])

  defp expand(tree, [], _), do: tree

  defp expand(tree, to_apply, applied) do
    [formula | rest] = sort_formulas(to_apply)

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

  @spec sort_formulas([TableauxNode.t()]) :: [TableauxNode.t()]
  defp sort_formulas(list) do
    Enum.sort_by(
      list,
      &Rules.get_type/1,
      &Rules.compare_operators(&1, &2)
    )
  end

  @spec add_expansion(BinTree.t(), map(), boolean()) :: BinTree.t()
  defp add_expansion(tree, expansion, source_found \\ false, path \\ [])

  defp add_expansion(nil, _, _, _), do: nil

  defp add_expansion(
         %{left: nil, right: nil} = tree,
         %{type: :branch, result: [left, right], source: source_id},
         source_found,
         path
       ) do
    source_found = source_id == tree.value.nid || source_found

    cond do
      tree.value.closed ->
        tree

      source_found ->
        BinTree.add_branch_node(tree, %BinTree{
          value: nil,
          left: %BinTree{value: left} |> close_branch([tree.value | path]),
          right: %BinTree{value: right} |> close_branch([tree.value | path])
        })

      true ->
        tree
    end
  end

  defp add_expansion(
         %{left: left, right: right} = tree,
         %{type: :branch, source: source_id} = expansion,
         source_found,
         path
       ) do
    source_found = source_id == tree.value.nid || source_found

    %BinTree{
      tree
      | left: add_expansion(left, expansion, source_found, [tree.value | path]),
        right: add_expansion(right, expansion, source_found, [tree.value | path])
    }
  end

  defp add_expansion(
         %{left: nil, right: nil} = tree,
         %{type: :linear, result: list, source: source_id},
         source_found,
         path
       ) do
    source_found = source_id == tree.value.nid || source_found

    cond do
      tree.value.closed ->
        tree

      source_found ->
        tree |> BinTree.add_linear_node(BinTree.from_list(list) |> close_branch(list ++ path))

      true ->
        tree
    end
  end

  defp add_expansion(
         %{left: left, right: right} = tree,
         %{type: :linear, source: source_id} = expansion,
         source_found,
         path
       ) do
    source_found = source_id == tree.value.nid || source_found

    %BinTree{
      tree
      | left: add_expansion(left, expansion, source_found, [tree.value | path]),
        right: add_expansion(right, expansion, source_found, [tree.value | path])
    }
  end

  defp add_expansion(tree, %{type: :atom}, _, _), do: tree

  @spec close_branch(BinTree.t(), [TableauxNode.t()]) :: BinTree.t()
  defp close_branch(%{value: value, left: nil, right: nil} = tree, path) do
    inverted_formula = invert_sign(value)

    %BinTree{
      tree
      | value: %TableauxNode{
          value
          | closed: Enum.any?(path, fn formula -> equal?(inverted_formula, formula) end)
        }
    }
  end

  defp close_branch(%{value: value, left: left, right: right} = tree, path) do
    new_tree = %BinTree{
      tree
      | left: close_branch(left, [value | path]),
        right: close_branch(right, [value | path])
    }

    %BinTree{new_tree | value: %{closed: branch_closed?(new_tree)}}
  end

  @spec branch_closed?(BinTree.t()) :: boolean()
  defp branch_closed?(nil), do: true

  defp branch_closed?(%{value: %{closed: closed}, left: nil, right: nil}), do: closed

  defp branch_closed?(%{left: left, right: right}) do
    branch_closed?(left) && branch_closed?(right)
  end

  @spec invert_sign(TableauxNode.t()) :: TableauxNode.t()
  defp invert_sign(%{sign: :T} = formula), do: %TableauxNode{formula | sign: :F}
  defp invert_sign(%{sign: :F} = formula), do: %TableauxNode{formula | sign: :T}

  defp equal?(%{formula: formula, sign: sign}, %{formula: formula, sign: sign}), do: true
  defp equal?(%{formula: _, sign: _}, %{formula: _, sign: _}), do: false
end
