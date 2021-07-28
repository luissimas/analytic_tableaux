defmodule Rules do
  @moduledoc """
  Tableaux expansion rules
  """

  def apply_rule(formula), do: rule(formula)

  # Tp&q => Tp, Tq
  defp rule(%{sign: :T, formula: {:and, a, b}}) do
    [%{sign: :T, formula: a}, %{sign: :T, formula: b}]
  end

  # Fp&q => Fp . Fq
  defp rule(%{sign: :F, formula: {:and, a, b}}) do
    branch(%{sign: :F, formula: a}, %{sign: :F, formula: b})
  end

  # Tp|q => Tp . Fq
  defp rule(%{sign: :T, formula: {:or, a, b}}) do
    branch(%{sign: :T, formula: a}, %{sign: :T, formula: b})
  end

  # Fp|q => Fp . Fq
  defp rule(%{sign: :F, formula: {:or, a, b}}) do
    [%{sign: :F, formula: a}, %{sign: :F, formula: b}]
  end

  # Tp->q => Fp, Tq
  defp rule(%{sign: :T, formula: {:implies, a, b}}) do
    branch(%{sign: :F, formula: a}, %{sign: :T, formula: b})
  end

  # Fp->q => Tp, Fq
  defp rule(%{sign: :F, formula: {:implies, a, b}}) do
    [%{sign: :T, formula: a}, %{sign: :F, formula: b}]
  end

  # T!p => Fp
  defp rule(%{sign: :T, formula: {:not, a}}) do
    %{sign: :F, formula: a}
  end

  # F!p => Tp
  defp rule(%{sign: :F, formula: {:not, a}}) do
    %{sign: :T, formula: a}
  end

  # Implement branches
  defp branch(a, b) do
    %{left: a, right: b}
  end
end
