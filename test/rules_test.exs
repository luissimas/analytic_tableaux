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
    assert Rules.apply_rule(f1()) ==
             {:linear,
              [
                %Formula{sign: :T, formula: :p},
                %Formula{sign: :T, formula: :q}
              ]}

    assert Rules.apply_rule(f2()) == {
             :branch,
             [
               %Formula{sign: :F, formula: :p},
               %Formula{sign: :F, formula: :q}
             ]
           }
  end

  test "or rules" do
    assert Rules.apply_rule(f3()) ==
             {:branch,
              [
                %Formula{sign: :T, formula: :p},
                %Formula{sign: :T, formula: :q}
              ]}

    assert Rules.apply_rule(f4()) == {
             :linear,
             [
               %Formula{sign: :F, formula: :p},
               %Formula{sign: :F, formula: :q}
             ]
           }
  end

  test "implies rules" do
    assert Rules.apply_rule(f5()) ==
             {:branch,
              [
                %Formula{sign: :F, formula: :p},
                %Formula{sign: :T, formula: :q}
              ]}

    assert Rules.apply_rule(f6()) ==
             {:linear,
              [
                %Formula{sign: :T, formula: :p},
                %Formula{sign: :F, formula: :q}
              ]}
  end

  test "not rules" do
    assert Rules.apply_rule(f7()) == {:linear, [%Formula{sign: :F, formula: :p}, nil]}
    assert Rules.apply_rule(f8()) == {:linear, [%Formula{sign: :T, formula: :p}, nil]}
  end
end
