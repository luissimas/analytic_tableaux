defmodule Parser do
  @moduledoc """
    Parser for propositional logic formulas
  """

  @spec parse(binary()) :: list(TableauxNode.t())
  def parse(input) do
    input
    |> String.split([",", "|-"])
    |> Enum.map(&parse_formula/1)
    |> create_nodes
  end

  @spec parse_formula(bitstring()) :: Expression.t()
  defp parse_formula(input) do
    {:ok, tokens, _} = input |> String.to_charlist() |> :lexer.string()

    {:ok, result} = :parser.parse(tokens)

    result
  end

  @spec create_nodes(list(Expression.t())) :: list(TableauxNode.t()) | TableauxNode.t()
  defp create_nodes(list, acc \\ 0)

  defp create_nodes([formula | []], acc),
    do: [%TableauxNode{formula: formula, sign: :F, nid: acc}]

  defp create_nodes([formula | tail], acc),
    do: [%TableauxNode{formula: formula, sign: :T, nid: acc} | create_nodes(tail, acc + 1)]
end
