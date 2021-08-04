defmodule Rules do
  @moduledoc """
  Tableaux expansion rules
  """
  @spec compare_operators(atom(), atom()) :: boolean()
  def compare_operators(:linear, _), do: true
  def compare_operators(_, :branch), do: true
  def compare_operators(_, _), do: false

  @spec apply_rule(TableauxNode.t(), integer()) :: map()
  def apply_rule(formula, base_id) do
    %{type: get_type(formula), result: rule(formula, base_id), source: base_id}
  end

  @spec is_linear?(TableauxNode.t()) :: boolean()
  def is_linear?(formula), do: type(formula) == :linear

  @spec is_branch?(TableauxNode.t()) :: boolean()
  def is_branch?(formula), do: type(formula) == :branch

  @spec get_type(TableauxNode.t()) :: :atom | :branch | :linear
  def get_type(formula), do: type(formula)

  defp type(%{sign: :T, formula: {:and, _, _}}), do: :linear
  defp type(%{sign: :F, formula: {:and, _, _}}), do: :branch
  defp type(%{sign: :T, formula: {:or, _, _}}), do: :branch
  defp type(%{sign: :F, formula: {:or, _, _}}), do: :linear
  defp type(%{sign: :T, formula: {:implies, _, _}}), do: :branch
  defp type(%{sign: :F, formula: {:implies, _, _}}), do: :linear
  defp type(%{sign: :T, formula: {:not, _}}), do: :linear
  defp type(%{sign: :F, formula: {:not, _}}), do: :linear
  defp type(%{formula: atom}) when is_atom(atom), do: :atom

  # Tp&q => Tp, Tq
  defp rule(%{sign: :T, formula: {:and, a, b}, nid: source}, base_id) do
    [
      %TableauxNode{sign: :T, formula: a, source: source, nid: base_id + 1},
      %TableauxNode{sign: :T, formula: b, source: source, nid: base_id + 2}
    ]
  end

  # Fp&q => Fp . Fq
  defp rule(%{sign: :F, formula: {:and, a, b}, nid: source}, base_id) do
    [
      %TableauxNode{sign: :F, formula: a, source: source, nid: base_id + 1},
      %TableauxNode{sign: :F, formula: b, source: source, nid: base_id + 2}
    ]
  end

  # Tp|q => Tp . Fq
  defp rule(%{sign: :T, formula: {:or, a, b}, nid: source}, base_id) do
    [
      %TableauxNode{sign: :T, formula: a, source: source, nid: base_id + 1},
      %TableauxNode{sign: :T, formula: b, source: source, nid: base_id + 2}
    ]
  end

  # Fp|q => Fp . Fq
  defp rule(%{sign: :F, formula: {:or, a, b}, nid: source}, base_id) do
    [
      %TableauxNode{sign: :F, formula: a, source: source, nid: base_id + 1},
      %TableauxNode{sign: :F, formula: b, source: source, nid: base_id + 2}
    ]
  end

  # Tp->q => Fp, Tq
  defp rule(%{sign: :T, formula: {:implies, a, b}, nid: source}, base_id) do
    [
      %TableauxNode{sign: :F, formula: a, source: source, nid: base_id + 1},
      %TableauxNode{sign: :T, formula: b, source: source, nid: base_id + 2}
    ]
  end

  # Fp->q => Tp, Fq
  defp rule(%{sign: :F, formula: {:implies, a, b}, nid: source}, base_id) do
    [
      %TableauxNode{sign: :T, formula: a, source: source, nid: base_id + 1},
      %TableauxNode{sign: :F, formula: b, source: source, nid: base_id + 2}
    ]
  end

  # T!p => Fp
  defp rule(%{sign: :T, formula: {:not, a}, nid: source}, base_id) do
    [%TableauxNode{sign: :F, formula: a, source: source, nid: base_id + 1}]
  end

  # F!p => Tp
  defp rule(%{sign: :F, formula: {:not, a}, nid: source}, base_id) do
    [%TableauxNode{sign: :T, formula: a, source: source, nid: base_id + 1}]
  end

  # F/T p
  defp rule(%{formula: atom} = formula, _) when is_atom(atom), do: formula

  # Implement branches
  # defp branch(a, b) do
  #   %{left: a, right: b}
  # end
end
