defmodule Parser do
  @moduledoc """
    Parser for propositional logic formulas
  """

  @spec parse(String.t()) :: [Formula.t()]
  def parse(input) do
    if String.contains?(input, "|-") do
      parsed =
        input
        |> String.split([",", "|-"])
        |> Enum.reject(fn x -> x == "" end)
        |> Enum.map(&parse_formula/1)

      error =
        Enum.find(parsed, nil, fn
          {:ok, _} -> false
          {:error, _} -> true
        end)

      case error do
        nil ->
          signed_formulas = sign_formulas(Enum.map(parsed, fn {:ok, formula} -> formula end))
          {:ok, signed_formulas}

        error ->
          error
      end
    else
      {:error, "syntax error, missing |- operator"}
    end
  end

  @spec parse_formula(String.t()) :: {:ok, Formula.formula()} | {:error, String.t()}
  defp parse_formula(input) do
    {:ok, tokens, _} = input |> String.to_charlist() |> :lexer.string()

    case :parser.parse(tokens) do
      {:ok, result} -> {:ok, result}
      {:error, {_, :parser, error}} -> {:error, Enum.join(error, "")}
    end
  end

  @spec sign_formulas([Formula.formula()]) :: [Formula.t()]
  defp sign_formulas([formula | []]), do: [%Formula{formula: formula, sign: :F}]

  defp sign_formulas([formula | tail]),
    do: [%Formula{formula: formula, sign: :T} | sign_formulas(tail)]
end
