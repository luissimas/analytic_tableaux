defmodule RulesTest do
  use ExUnit.Case, async: true

  defp f1(), do: %{sign: :T, formula: {:and, :p, :q}}
  defp f2(), do: %{sign: :F, formula: {:and, :p, :q}}
  defp f3(), do: %{sign: :T, formula: {:or, :p, :q}}
  defp f4(), do: %{sign: :F, formula: {:or, :p, :q}}
  defp f5(), do: %{sign: :T, formula: {:implies, :p, :q}}
  defp f6(), do: %{sign: :F, formula: {:implies, :p, :q}}
  defp f7(), do: %{sign: :T, formula: {:not, :p}}
  defp f8(), do: %{sign: :F, formula: {:not, :p}}

  defp branch(a, b) do
    {a, b}
  end

  test "and rules" do
    assert Rules.apply_rule(f1()) == [%{sign: :T, formula: :p}, %{sign: :T, formula: :q}]
    assert Rules.apply_rule(f2()) == branch(%{sign: :F, formula: :p}, %{sign: :F, formula: :q})
  end

  test "or rules" do
    assert Rules.apply_rule(f3()) == branch(%{sign: :T, formula: :p}, %{sign: :T, formula: :q})
    assert Rules.apply_rule(f4()) == [%{sign: :F, formula: :p}, %{sign: :F, formula: :q}]
  end

  test "implies rules" do
    assert Rules.apply_rule(f5()) == branch(%{sign: :F, formula: :p}, %{sign: :T, formula: :q})
    assert Rules.apply_rule(f6()) == [%{sign: :T, formula: :p}, %{sign: :F, formula: :q}]
  end

  test "not rules" do
    assert Rules.apply_rule(f7()) == %{sign: :F, formula: :p}
    assert Rules.apply_rule(f8()) == %{sign: :T, formula: :p}
  end
end
