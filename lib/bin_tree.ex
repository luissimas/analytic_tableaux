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

  @spec create_node(Expression.t()) :: t() | nil
  def create_node(nil), do: nil
  def create_node(value), do: %BinTree{value: value}

  @spec add_linear_node(t(), t()) :: t()
  def add_linear_node(%{left: nil} = tree, node) do
    %BinTree{tree | left: node}
  end

  def add_linear_node(tree, node) do
    %BinTree{tree | left: add_linear_node(tree.left, node)}
  end

  @spec add_branch_node(t(), t()) :: t()
  def add_branch_node(%{left: nil, right: nil} = tree, node) do
    %BinTree{tree | left: node.left, right: node.right}
  end

  def add_branch_node(tree, node) do
    %BinTree{tree | left: add_branch_node(tree.left, node)}
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
