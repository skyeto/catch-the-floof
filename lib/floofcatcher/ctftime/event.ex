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
end
