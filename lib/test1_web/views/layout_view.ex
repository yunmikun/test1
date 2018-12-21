defmodule Test1Web.LayoutView do
  use Test1Web, :view

  import Plug.Conn, only: [get_session: 2]
end
