defmodule Rules do
  @moduledoc """
  Tableaux expansion rules
  """

  def apply_rule(formula), do: rule(formula)

  defp rule({:T, :and, op1, op2}), do: [{:T, op1}, {:T, op2}]
  defp rule({:F, :and, op1, op2}), do: {:or, {:F, op1}, {:F, op2}}
  defp rule({:T, :or, op1, op2}), do: {:or, {:T, op1}, {:F, op2}}
  defp rule({:F, :or, op1, op2}), do: [{:F, op1}, {:F, op2}]
  defp rule({:T, :implies, op1, op2}), do: {:or, {:F, op1}, {:T, op2}}
  defp rule({:F, :implies, op1, op2}), do: [{:T, op1}, {:F, op2}]
  defp rule({:T, :not, op}), do: {:F, op}
  defp rule({:F, :not, op}), do: {:T, op}
end
