defmodule Test1Web.EventControllerTest do
  use Test1Web.ConnCase

  alias Test1Web.Router.Helpers, as: Routes
  alias Test1.Accounts
  alias Test1.Events

  @dummy_cover %Plug.Upload{
    content_type: "image/jpeg",
    filename: "test.jpg",
    path: "test/test1/events/test.jpg"
  }
  @create_attrs %{
    address: "some address",
    city: "some city",
    cover: @dummy_cover,
    date: ~N[2010-04-17 14:00:00],
    description: "some description",
    link: "some link",
    title: "some title"
  }
  @update_attrs %{
    address: "some updated address",
    city: "some updated city",
    cover: @dummy_cover,
    date: ~N[2011-05-18 15:01:01],
    description: "some updated description",
    link: "some updated link",
    title: "some updated title"
  }
  @invalid_attrs %{
    address: nil,
    city: nil,
    cover: nil,
    date: nil,
    description: nil,
    link: nil,
    title: nil
  }
  @user_create_attrs %{
    bio: "some bio",
    email: "some@email.com",
    name: "some name",
    password: "some password"
  }

  def event_fixture(user) do
    {:ok, event} = Events.create_event(user, @create_attrs)
    event
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} = attrs
    |> Enum.into(@user_create_attrs)
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
    test "lists all events", %{conn: conn} do
      conn = conn
      |> get(Routes.event_path(conn, :index))
      assert html_response(conn, 200) =~ "html"
    end
  end

  describe "new event" do
    setup [:create_event_and_users]

    test "renders form", %{conn: conn, user: user} do
      conn = conn
      |> log_in_as(user)
      |> get(Routes.event_path(conn, :new))
      assert html_response(conn, 200) =~ "html"
    end
  end

  describe "create event" do
    setup [:create_event_and_users]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn
      |> log_in_as(user)
      |> post(Routes.event_path(conn, :create), event: @create_attrs)
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.event_path(conn, :show, id)
      conn = conn
      |> get(Routes.event_path(conn, :show, id))
      assert html_response(conn, 200) =~ "html"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn
      |> log_in_as(user)
      |> post(Routes.event_path(conn, :create), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "html"
    end

    test "doesn't work without signing in", %{conn: conn} do
      conn = conn
      |> post(Routes.event_path(conn, :create), event: @create_attrs)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "edit event" do
    setup [:create_event_and_users]

    test "renders form for editing chosen event", %{conn: conn, event: event, user: user} do
      conn = conn
      |> log_in_as(user)
      |> get(Routes.event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "html"
    end

    test "doesn't work when attempted by a different user", %{conn: conn, event: event, another_user: another_user} do
      conn = conn
      |> log_in_as(another_user)
      |> get(Routes.event_path(conn, :edit, event))
      assert redirected_to(conn) =~ Routes.event_path(conn, :show, event)
    end
  end

  describe "update event" do
    setup [:create_event_and_users]

    test "redirects when data is valid", %{conn: conn, event: event, user: user} do
      conn = conn
      |> log_in_as(user)
      |> put(Routes.event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) == Routes.event_path(conn, :show, event)
      conn = conn
      |> get(Routes.event_path(conn, :show, event))
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event, user: user} do
      conn = conn
      |> log_in_as(user)
      |> put(Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops"
    end

    test "doesn't work when attempted by a different user", %{conn: conn, event: event, another_user: another_user} do
      conn = conn
      |> log_in_as(another_user)
      |> put(Routes.event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) =~ Routes.event_path(conn, :show, event)
    end
  end

  describe "delete event" do
    setup [:create_event_and_users]

    test "deletes chosen event", %{conn: conn, event: event, user: user} do
      conn = conn
      |> log_in_as(user)
      |> delete(Routes.event_path(conn, :delete, event))
      assert redirected_to(conn) == Routes.event_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.event_path(conn, :show, event))
      end
    end

    test "doesn't work when attempted by a different user", %{conn: conn, event: event, another_user: another_user} do
      conn = conn
      |> log_in_as(another_user)
      |> delete(Routes.event_path(conn, :delete, event))
      assert redirected_to(conn) =~ Routes.event_path(conn, :show, event)
    end
  end

  defp create_event_and_users(_) do
    user = user_fixture()
    another_user = user_fixture(email: "another@email.com")
    event = event_fixture(user)
    {:ok, event: event, user: user, another_user: another_user}
  end
end
