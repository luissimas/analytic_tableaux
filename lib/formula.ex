defmodule Formula do
  @moduledoc """
  Representation of signed formulas from classical propositional logic.
  """

  @type formula :: {:implies | :and | :or, formula(), formula()} | {:not, atom()} | atom()

  @type t() :: %Formula{formula: formula(), sign: :T | :F}

  defstruct [:formula, :sign]
end
