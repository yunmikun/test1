defmodule Test1Web.PageController do
  use Test1Web, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: event_path(conn, :index))
  end
end
