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

    is_valid?(head, [], tail)
  end

  @spec is_valid?(Formula.t(), [Formula.t()], [Formula.t()]) :: boolean()
  defp is_valid?(formula, path, to_expand) do
    cond do
      closed?(formula, path) ->
        true

      Rules.can_expand?(formula) ->
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

            is_valid?(left, new_path, to_expand) and is_valid?(right, new_path, to_expand)
        end

      Enum.empty?(to_expand) ->
        false

      true ->
        # Get the first formula from the stack, and call is_valid? on it
        [head | tail] = to_expand
        new_path = [formula | path]

        is_valid?(head, new_path, tail)
    end
  end

  @spec closed?(Formula.t(), [Formula.t()]) :: boolean()
  defp closed?(formula, path), do: Enum.any?(path, &contradiction?(formula, &1))

  @spec contradiction?(Formula.t(), Formula.t()) :: boolean()
  defp contradiction?(%{sign: s1, formula: f}, %{sign: s2, formula: f}) when s1 != s2, do: true
  defp contradiction?(_, _), do: false
end
