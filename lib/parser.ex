defmodule Parser do
  @moduledoc """
    Parser for propositional logic formulas
  """

  @spec parse(binary()) :: map()
  def parse(input) do
    {:ok, tokens, _} = input |> String.to_charlist() |> :lexer.string()

    {:ok, result} = :parser.parse(tokens)

    result
  end
end
