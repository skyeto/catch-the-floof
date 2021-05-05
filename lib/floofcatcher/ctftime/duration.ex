defmodule Floofcatcher.Ctftime.Duration do
  defstruct [
    :hours,
    :days
  ]

  @type t :: %__MODULE__{
    hours: integer,
    days: integer
  }
end
