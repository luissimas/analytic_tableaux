defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node, it can be either a formula or a list of formulas.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{
          value: TableauxNode.t() | nil,
          left: t() | nil,
          right: t() | nil
        }

  defstruct [:value, left: nil, right: nil]

  @spec from_list(list(TableauxNode.t())) :: t() | nil
  def from_list([]) do
    nil
  end

  def from_list([head | tail]) do
    %BinTree{
      value: head,
      left: from_list(tail)
    }
  end

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
