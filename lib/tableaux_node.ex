defmodule TableauxNode do
  @moduledoc """
  A node in the tableaux resolution tree
  """

  @type t :: %TableauxNode{
          formula: Expression.t(),
          sign: atom(),
          source: nil | integer(),
          nid: nil | integer(),
          closed: boolean()
        }

  defstruct [:formula, :sign, :nid, source: nil, closed: false]
end
