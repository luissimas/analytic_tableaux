defmodule Rules do
  @moduledoc """
  Tableaux expansion rules
  """

  @spec apply_rule(Formula.t()) :: {:atom | :branch | :linear, [Formula.t()]}
  def apply_rule(formula) do
    {get_type(formula), get_expansion(formula)}
  end

  @spec can_expand?(Formula.t()) :: boolean()
  def can_expand?(nil), do: false

  def can_expand?(formula) do
    case get_type(formula) do
      :atom -> false
      _ -> true
    end
  end

  @spec get_type(Formula.t()) :: :linear | :branch | :atom
  def get_type(%{sign: :T, formula: {:and, _, _}}), do: :linear
  def get_type(%{sign: :F, formula: {:and, _, _}}), do: :branch
  def get_type(%{sign: :T, formula: {:or, _, _}}), do: :branch
  def get_type(%{sign: :F, formula: {:or, _, _}}), do: :linear
  def get_type(%{sign: :T, formula: {:implies, _, _}}), do: :branch
  def get_type(%{sign: :F, formula: {:implies, _, _}}), do: :linear
  def get_type(%{sign: :T, formula: {:not, _}}), do: :linear
  def get_type(%{sign: :F, formula: {:not, _}}), do: :linear
  def get_type(%{formula: _}), do: :atom

  @spec get_expansion(Formula.t()) :: [Formula.t()]
  defp get_expansion(%{sign: :T, formula: {:and, a, b}}),
    do: [%Formula{sign: :T, formula: a}, %Formula{sign: :T, formula: b}]

  defp get_expansion(%{sign: :F, formula: {:and, a, b}}),
    do: [%Formula{sign: :F, formula: a}, %Formula{sign: :F, formula: b}]

  defp get_expansion(%{sign: :T, formula: {:or, a, b}}),
    do: [%Formula{sign: :T, formula: a}, %Formula{sign: :T, formula: b}]

  defp get_expansion(%{sign: :F, formula: {:or, a, b}}),
    do: [%Formula{sign: :F, formula: a}, %Formula{sign: :F, formula: b}]

  defp get_expansion(%{sign: :T, formula: {:implies, a, b}}),
    do: [%Formula{sign: :F, formula: a}, %Formula{sign: :T, formula: b}]

  defp get_expansion(%{sign: :F, formula: {:implies, a, b}}),
    do: [%Formula{sign: :T, formula: a}, %Formula{sign: :F, formula: b}]

  defp get_expansion(%{sign: :T, formula: {:not, a}}), do: [%Formula{sign: :F, formula: a}, nil]

  defp get_expansion(%{sign: :F, formula: {:not, a}}), do: [%Formula{sign: :T, formula: a}, nil]

  defp get_expansion(_), do: []
end
