defmodule Rules do
  @moduledoc """
  Tableaux expansion rules
  """

  @spec get_type(Expression.t()) :: atom()
  def get_type(formula), do: type(formula)

  @spec apply_rule(Expression.t()) ::
          list(Expression.t()) | %{left: Expression.t(), right: Expression.t()}
  def apply_rule(formula), do: rule(formula)

  @spec is_linear?(Expression.t()) :: boolean()
  def is_linear?(formula), do: type(formula) == :linear

  @spec is_branch?(Expression.t()) :: boolean()
  def is_branch?(formula), do: type(formula) == :branch

  defp type(%{sign: :T, formula: {:and, _, _}}), do: :linear
  defp type(%{sign: :F, formula: {:and, _, _}}), do: :branch
  defp type(%{sign: :T, formula: {:or, _, _}}), do: :branch
  defp type(%{sign: :F, formula: {:or, _, _}}), do: :linear
  defp type(%{sign: :T, formula: {:implies, _, _}}), do: :branch
  defp type(%{sign: :F, formula: {:implies, _, _}}), do: :linear
  defp type(%{sign: :T, formula: {:not, _}}), do: :linear
  defp type(%{sign: :F, formula: {:not, _}}), do: :linear
  defp type(%{formula: atom}) when is_atom(atom), do: :linear

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

  # F/T p
  defp rule(%{formula: atom} = formula) when is_atom(atom), do: formula

  # Implement branches
  defp branch(a, b) do
    %{left: a, right: b}
  end
end
