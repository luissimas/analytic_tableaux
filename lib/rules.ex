defmodule Rules do
  @moduledoc """
  Tableaux expansion rules
  """
  @spec apply_linear_rules(list(Expression.t())) :: list(Expression.t())
  def apply_linear_rules([]), do: []

  def apply_linear_rules(list) do
    applyed =
      list
      |> Enum.filter(&is_linear?/1)
      |> Enum.map(&apply_rule/1)
      |> List.flatten()

    applyed ++ apply_linear_rules(applyed)
  end

  @spec apply_branch_rules(list(Expression.t())) :: list(Expression.t())
  def apply_branch_rules(list) do
    list
    |> Enum.filter(&is_branch?/1)
    |> Enum.map(&apply_rule/1)
  end

  @spec apply_rule(Expression.t()) ::
          list(Expression.t()) | %{left: Expression.t(), right: Expression.t()}
  defp apply_rule(formula), do: rule(formula)

  @spec is_linear?(Expression.t()) :: boolean()
  defp is_linear?(formula), do: type(formula) == :linear

  @spec is_branch?(Expression.t()) :: boolean()
  defp is_branch?(formula), do: type(formula) == :branch

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
