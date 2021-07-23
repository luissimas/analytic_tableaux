defmodule Parser do
  @moduledoc """
    Parser for propositional logic formulas
  """

  @spec parse(binary()) :: list()
  def parse(input) do
    {:ok, tokens, _} = input |> String.to_charlist() |> :lexer.string()
    tokens
  end
end
