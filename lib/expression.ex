defmodule Expression do
  @moduledoc """
  Base module to represent an signed formula from classical
  propositional logic as a (kind of ?) AST
  """

  @type operator :: atom()

  @typedoc """
  A unsigned formula in the format {:operator, :operand, :operand}
  """
  @type t :: {operator(), atom() | t(), atom() | t()} | {operator(), t()}

  # @typedoc """
  # A signed formula from classical propositional formula
  # """
  # @type t :: %{
  #         sign: :T | :F,
  #         formula: formula()
  #       }
end
