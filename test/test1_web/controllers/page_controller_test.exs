defmodule Test1Web.PageControllerTest do
  use Test1Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn, 302) == "/events"
  end
end
