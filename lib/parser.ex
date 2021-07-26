defmodule Parser do
  @moduledoc """
    Parser for propositional logic formulas
  """

  @spec parse(binary()) :: map()
  def parse(input) do
    [antecedents, consequent] = String.split(input, "|-")

    antecedents =
      antecedents
      |> String.split(",")
      |> Enum.map(fn formula ->
        formula
        |> parse_formula()
        |> add_sign(:T)
      end)

    consequent =
      consequent
      |> parse_formula()
      |> add_sign(:F)

    antecedents ++ [consequent]
  end

  defp parse_formula(input) do
    {:ok, tokens, _} = input |> String.to_charlist() |> :lexer.string()

    {:ok, result} = :parser.parse(tokens)

    result
  end

  defp add_sign(formula, sign), do: %{sign: sign, formula: formula}
end
