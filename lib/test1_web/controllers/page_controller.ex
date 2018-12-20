defmodule Test1Web.PageController do
  use Test1Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
