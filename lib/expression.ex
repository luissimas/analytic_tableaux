defmodule Expression do
  @moduledoc """
  Base module to represent an signed formula from classical
  propositional logic as a (kind of ?) AST
  """

  @typedoc """
  Type to represent an expression (signed formula)
  """
  @type expr :: %Expression{
          operator: :and | :or | :implies | :not | :atom,
          sign: :T | :F,
          left: expr() | nil,
          right: expr() | nil
        }

  defstruct [:operator, :sign, :left, :right]
end
