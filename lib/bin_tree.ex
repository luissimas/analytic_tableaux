defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node, it can be either a formula or a list of formulas.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{
          value: Expression.t() | list(Expression.t()),
          left: t() | nil,
          right: t() | nil
        }

  defstruct [:value, left: nil, right: nil]

  @spec from_list(list(Expression.t())) :: t() | nil
  def from_list([]) do
    nil
  end

  def from_list([head | tail]) do
    %BinTree{
      value: head,
      left: from_list(tail)
    }
  end
end

# defimpl Inspect, for: BinTree do
#   import Inspect.Algebra

#   # A custom inspect instance purely for the tests, this makes error messages
#   # much more readable.
#   #
#   # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
#   def inspect(%BinTree{value: value, left: left, right: right}, opts) do
#     concat([
#       "(",
#       to_doc(value, opts),
#       ":",
#       if(left, do: to_doc(left, opts), else: ""),
#       ":",
#       if(right, do: to_doc(right, opts), else: ""),
#       ")"
#     ])
#   end
# end
