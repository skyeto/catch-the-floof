defmodule FloofcatcherWeb.Discord.AddController do
  use FloofcatcherWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    with  client_id <- "831959982806794242",
          permissions <- "8",
          scope <- "bot",
          url <- "https://discord.com/api/oauth2/authorize?client_id=#{client_id}&scope=#{scope}&permissions=#{permissions}" do
      redirect(conn, external: url)
    end
  end
end
