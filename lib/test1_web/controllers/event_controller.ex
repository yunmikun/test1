defmodule Test1Web.EventController do
  use Test1Web, :controller

  alias Test1.Events
  alias Test1.Events.Event

  import Test1.AuthentificationHelper

  # Public actions:

  def index(conn, _params) do
    events = Events.list_events()
    conn
    |> render("index.html", events: events, active: nil)
  end

  def upcomming(conn, _params) do
    events = Events.list_upcomming_events()
    conn
    |> render("index.html", events: events, active: :upcomming)
  end

  def past(conn, _params) do
    events = Events.list_past_events()
    conn
    |> render("index.html", events: events, active: :past)
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    conn
    |> render("show.html", event: event)
  end

  # Actions recuiring to sign in:
  plug :authenticate_user when action in [:new, :create, :edit, :update, :delete]

  def new(conn, _params) do
    current_user = conn.assigns.current_user
    with {:ok, changeset} <- Events.change_event(current_user, %Event{user: current_user}) do
      conn
      |> render("new.html", changeset: changeset)
    end
  end

  def create(conn, %{"event" => event_params}) do
    case Events.create_event(conn.assigns.current_user, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
	conn
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    case Events.change_event(conn.assigns.current_user, event) do
      {:ok, changeset} ->
	conn
	|> render("edit.html", event: event, changeset: changeset)
      {:error, :wrong_user} ->
	conn
	|> put_flash(:error, "This event belongs to a different user!")
	|> redirect(to: event_path(conn, :show, event))
    end
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)
    case Events.update_event(conn.assigns.current_user, event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
	conn
        |> render("edit.html", event: event, changeset: changeset)
      {:error, :wrong_user} ->
	conn
	|> put_flash(:error, "This event belongs to a different user!")
	|> redirect(to: event_path(conn, :show, event))
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    case Events.delete_event(conn.assigns.current_user, event) do
      {:ok, _event} ->
	conn
	|> put_flash(:info, "Event deleted successfully.")
	|> redirect(to: event_path(conn, :index))
      {:error, :wrong_user} ->
	conn
	|> put_flash(:error, "This event belongs to a different user!")
	|> redirect(to: event_path(conn, :index))
    end
  end
end
