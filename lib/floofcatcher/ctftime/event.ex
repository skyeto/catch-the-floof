defmodule Floofcatcher.Ctftime.Event do
  defstruct [
    :id,
    :ctf_id,
    :title,
    :url,
    :restrictions,
    :format,
    :ctftime_url,
    :onsite,
    :location,
    :start,
    :duration,
    :weight
  ]

  @type t :: %__MODULE__{
    id: String.t(),
    ctf_id: integer,
    title: String.t(),
    url: String.t() | nil,
    restrictions: String.t() | nil,
    format: String.t() | nil,
    ctftime_url: String.t(),
    onsite: boolean | nil,
    location: String.t() | nil,
    start: DateTime.t(),
    duration: Floofcatcher.Ctftime.Duration.t()
  }
end
