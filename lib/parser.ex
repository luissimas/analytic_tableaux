defmodule Parser do
  @moduledoc """
    Parser for propositional logic formulas
  """

  @spec parse(String.t()) :: [Formula.t()]
  def parse(input) do
    input
    |> String.split([",", "|-"])
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.map(&parse_formula/1)
    |> sign_formulas
  end

  @spec parse_formula(String.t()) :: Formula.formula()
  defp parse_formula(input) do
    {:ok, tokens, _} = input |> String.to_charlist() |> :lexer.string()

    {:ok, result} = :parser.parse(tokens)

    result
  end

  @spec sign_formulas([Formula.formula()]) :: [Formula.t()]
  defp sign_formulas([formula | []]), do: [%Formula{formula: formula, sign: :F}]

  defp sign_formulas([formula | tail]),
    do: [%Formula{formula: formula, sign: :T} | sign_formulas(tail)]
end
