defmodule Tableaux do
  @moduledoc """
  Implementation of the Analytic Tableaux method.
  """

  @type t() :: {:valid | :invalid, [{Formula.t(), boolean()}]}

  @doc """
  Hello world.

  ## Examples

      iex> Tableaux.prove("p->q, p |- q")
      {:valid, []}

      iex> Tableaux.prove("p->q, p |- t")
      {:invalid, [{:p, true}, {:q, true}]}
  """
  @spec prove(String.t()) :: boolean()
  def prove(argument) do
    [head | tail] = Parser.parse(argument)

    is_valid?(head, [], tail)
  end

  @spec is_valid?(Formula.t(), [Formula.t()], [Formula.t()]) :: t()
  defp(is_valid?(formula, path, to_expand)) do
    cond do
      closed?(formula, path) ->
        {:valid, []}

      Rules.can_expand?(formula) ->
        expand(formula, path, to_expand)

      Enum.empty?(to_expand) ->
        {:invalid, counterproof(path)}

      true ->
        # Get the first formula from the stack, and call is_valid? on it
        [head | tail] = to_expand
        new_path = [formula | path]

        is_valid?(head, new_path, tail)
    end
  end

  @spec expand(Formula.t(), [Formula.t()], [Formula.t()]) :: t()
  defp expand(formula, path, to_expand) do
    # Expand the current formula, add the expansions to the stack,
    # then call is_valid? on the new expanded formulas
    {type, expanded} = Rules.apply_rule(formula)

    new_path = [formula | path]

    case type do
      :linear ->
        [first, second] = expanded

        is_valid?(first, new_path, [second | to_expand])

      :branch ->
        [left, right] = expanded

        {lvalue, lcounterproof} = is_valid?(left, new_path, to_expand)

        if lvalue == :valid do
          {rvalue, rcounterproof} = is_valid?(right, new_path, to_expand)

          {rvalue, rcounterproof}
        else
          {lvalue, lcounterproof}
        end
    end
  end

  @spec closed?(Formula.t(), [Formula.t()]) :: boolean()
  defp closed?(formula, path), do: Enum.any?(path, &contradiction?(formula, &1))

  @spec contradiction?(Formula.t(), Formula.t()) :: boolean()
  defp contradiction?(%{sign: s1, formula: f}, %{sign: s2, formula: f}) when s1 != s2, do: true
  defp contradiction?(_, _), do: false

  @spec counterproof([Formula.t()]) :: [{atom(), boolean()}]
  def counterproof(list) do
    list
    |> Enum.filter(fn formula -> Rules.get_type(formula) == :atom end)
    |> Enum.uniq()
    |> Enum.map(&evaluate/1)
  end

  @spec evaluate(Formula.t()) :: {Formula.formula(), boolean()}
  defp evaluate(%{formula: formula, sign: :F}), do: {formula, false}
  defp evaluate(%{formula: formula, sign: :T}), do: {formula, true}
end
