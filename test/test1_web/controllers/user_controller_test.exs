defmodule Test1Web.UserControllerTest do
  use Test1Web.ConnCase

  alias Test1Web.Router.Helpers, as: Routes
  alias Test1.Accounts

  @create_attrs %{
    bio: "some bio",
    email: "some@email.com",
    name: "some name",
    password: "some password"
  }
  @update_attrs %{
    bio: "some updated bio",
    email: "some_updated@email.com",
    name: "some updated name",
    password: "some updated password"
  }
  @invalid_attrs %{
    bio: nil,
    email: nil,
    name: nil,
    password: nil
  }

  def fixture(:user, attrs \\ %{}) do
    {:ok, user} = attrs
    |> Enum.into(@create_attrs)
    |> Accounts.create_user()
    user
  end

  @default_opts [
    store: :cookie,
    key: "foobar",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt",
    log: false
  ]
  @session_opts Plug.Session.init(@default_opts)

  defp log_in_as(conn, user) do
    conn
    |> Plug.Session.call(@session_opts)
    |> fetch_session()
    |> put_session(:user_id, user.id)
  end

  describe "index" do
    test "shows without errors", %{conn: conn} do
      conn = conn
      |> get(Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "html"
    end
  end

  describe "new user" do
    test "shows without errors", %{conn: conn} do
      conn = conn
      |> get(Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "html"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = conn
      |> post(Routes.user_path(conn, :create), user: @create_attrs)
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)
      conn = conn
      |> get(Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "#{@create_attrs.name}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = conn
      |> post(Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "html"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = conn
      |> log_in_as(user)
      |> get(Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "form"
    end

    test "doesn't work when attempted by a different user", %{conn: conn, user: user1, user2: user2} do
      conn = conn
      |> log_in_as(user1)
      |> get(Routes.user_path(conn, :edit, user2))
      assert redirected_to(conn) == Routes.user_path(conn, :show, user2)
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = conn
      |> log_in_as(user)
      |> put(Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated bio"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn
      |> log_in_as(user)
      |> put(Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "form"
    end

    test "doesn't work when attempted by a different user", %{conn: conn, user: user1, user2: user2} do
      conn = conn
      |> log_in_as(user1)
      |> put(Routes.user_path(conn, :update, user2, user: @update_attrs))
      assert redirected_to(conn) == Routes.user_path(conn, :show, user2)
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = conn
      |> log_in_as(user)
      |> delete(Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end

    test "doesn't work when attempted by a different user", %{conn: conn, user: user1, user2: user2} do
      conn = conn
      |> log_in_as(user1)
      |> delete(Routes.user_path(conn, :delete, user2))
      assert redirected_to(conn) == Routes.user_path(conn, :show, user2)
      conn = conn
      |> get(Routes.user_path(conn, :show, user1))
      assert html_response(conn, 200) =~ "#{user1.name}"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    user2 = fixture(:user, email: "another@email.com")
    {:ok, user: user, user2: user2}
  end
end
