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

  test "and rules" do
    assert Rules.apply_rule(f1()).expansion == [
             %TreeNode{sign: :T, formula: :p},
             %TreeNode{sign: :T, formula: :q}
           ]

    assert Rules.apply_rule(f2()).expansion == [
             %TreeNode{sign: :F, formula: :p},
             %TreeNode{sign: :F, formula: :q}
           ]
  end

  test "or rules" do
    assert Rules.apply_rule(f3()).expansion == [
             %TreeNode{sign: :T, formula: :p},
             %TreeNode{sign: :T, formula: :q}
           ]

    assert Rules.apply_rule(f4()).expansion == [
             %TreeNode{sign: :F, formula: :p},
             %TreeNode{sign: :F, formula: :q}
           ]
  end

  test "implies rules" do
    assert Rules.apply_rule(f5()).expansion == [
             %TreeNode{sign: :F, formula: :p},
             %TreeNode{sign: :T, formula: :q}
           ]

    assert Rules.apply_rule(f6()).expansion == [
             %TreeNode{sign: :T, formula: :p},
             %TreeNode{sign: :F, formula: :q}
           ]
  end

  test "not rules" do
    assert Rules.apply_rule(f7()).expansion == [%TreeNode{sign: :F, formula: :p}]
    assert Rules.apply_rule(f8()).expansion == [%TreeNode{sign: :T, formula: :p}]
  end
end
