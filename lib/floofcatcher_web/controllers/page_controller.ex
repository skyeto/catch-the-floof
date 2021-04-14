defmodule FloofcatcherWeb.PageController do
  use FloofcatcherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
