defmodule TableauxTest do
  use ExUnit.Case
  doctest Tableaux

  test "prove modus ponens" do
    assert Tableaux.prove("p->q, p |- q") == {:valid, []}
  end

  test "prove modus tollens" do
    assert Tableaux.prove("p->q, !q |- !p") == {:valid, []}
  end

  test "prove PHP1" do
    assert ProblemGenerator.generate(1) |> Tableaux.prove() == {:valid, []}
  end

  test "prove PHP2" do
    assert ProblemGenerator.generate(2) |> Tableaux.prove() == {:valid, []}
  end

  test "prove PHP3" do
    assert ProblemGenerator.generate(3) |> Tableaux.prove() == {:valid, []}
  end
end
