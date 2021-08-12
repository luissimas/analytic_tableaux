defmodule Tableaux do
  @moduledoc """
  Implementation of the Analytic Tableaux method.
  """
  @doc """
  Hello world.

  ## Examples

      iex> Tableaux.prove("p->q, p |- q")
      true

      iex> Tableaux.prove("p->q, p |- t")
      false
  """
  @spec prove(String.t()) :: boolean()
  def prove(argument) do
    [head | tail] = Parser.parse(argument)

    is_valid?(BinTree.from_node(head), [], tail)
  end

  @spec is_valid?(BinTree.t(), [TreeNode.t()], [TreeNode.t()]) :: boolean()
  def is_valid?(tree, path, to_expand)

  def is_valid?(nil, _, _), do: true

  def is_valid?(%{left: nil, right: nil, value: value} = tree, path, to_expand) do
    cond do
      closed?(value, path) ->
        true

      Rules.can_expand?(value) ->
        # Expand the current node, add the expansions to the tree and the stack,
        # then call is_valid? on the new tree created from the expansions
        %{tree: expanded_tree, expansion: expanded} = Rules.apply_rule(value)

        new_to_expand = sort_formulas(Enum.filter(expanded, &Rules.can_expand?/1) ++ to_expand)

        is_valid?(BinTree.add(tree, expanded_tree), path, new_to_expand)

      Enum.empty?(to_expand) ->
        false

      true ->
        # Expand the first element from the stack, add the expansions to the tree and the stack,
        # then call is_valid? on the new tree created from the expansions
        [head | tail] = to_expand

        %{tree: expanded_tree, expansion: expanded} = Rules.apply_rule(head)

        new_to_expand = sort_formulas(Enum.filter(expanded, &Rules.can_expand?/1) ++ tail)

        is_valid?(BinTree.add(tree, expanded_tree), path, new_to_expand)
    end
  end

  def is_valid?(%{left: left, right: right, value: value}, path, to_expand) do
    if closed?(value, path) do
      true
    else
      is_valid?(left, [value | path], to_expand) and is_valid?(right, [value | path], to_expand)
    end
  end

  @spec closed?(TreeNode.formula(), [TreeNode.formula()]) :: boolean()
  def closed?(formula, path), do: Enum.any?(path, &contradiction?(formula, &1))

  @spec contradiction?(TreeNode.t(), TreeNode.t()) :: boolean()
  def contradiction?(%{sign: s1, formula: f}, %{sign: s2, formula: f}) when s1 != s2, do: true
  def contradiction?(_, _), do: false

  @spec sort_formulas([TreeNode.t()]) :: [TreeNode.t()]
  defp sort_formulas(list) do
    Enum.sort_by(
      list,
      &Rules.get_type/1,
      &Rules.compare_operators(&1, &2)
    )
  end
end
