defmodule Parser do
  @moduledoc """
    Parser for propositional logic formulas
  """

  @spec parse(binary()) :: list(Expression.t())
  def parse(input) do
    input
    |> String.split([",", "|-"])
    |> Enum.map(&parse_formula/1)
    |> sign_list
  end

  @spec parse_formula(bitstring()) :: Expression.formula()
  defp parse_formula(input) do
    {:ok, tokens, _} = input |> String.to_charlist() |> :lexer.string()

    {:ok, result} = :parser.parse(tokens)

    result
  end

  @spec sign_list(list(Expression.formula())) :: list(Expression.t()) | Expression.t()
  defp sign_list([formula | []]), do: [add_sign(formula, :F)]
  defp sign_list([formula | tail]), do: [add_sign(formula, :T) | sign_list(tail)]

  defp add_sign(formula, sign), do: %{sign: sign, formula: formula}
end
