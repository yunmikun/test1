defmodule Test1Web.UserController do
  use Test1Web, :controller

  alias Test1.Accounts
  alias Test1.Accounts.User

  import Test1.AuthentificationHelper

  # Public actions:

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    new_user = %User{}
    with {:ok, changeset} <- Accounts.change_user(new_user, new_user) do
      conn
      |> render("new.html", changeset: changeset)
    end
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome here!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  # Actions recuiring to sign in:
  plug :authenticate_user when action in [:edit, :update, :delete]

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    case Accounts.change_user(conn.assigns.current_user, user) do
      {:ok, changeset} ->
	conn
	|> render("edit.html", user: user, changeset: changeset)
      {:error, :wrong_user} ->
	conn
	|> put_flash(:error, "It's not your profile! You can not change it.")
	|> redirect(to: user_path(conn, :show, user))
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(conn.assigns.current_user, user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile info updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
	conn
        |> render("edit.html", user: user, changeset: changeset)
      {:error, :wrong_user} ->
	conn
	|> put_flash(:error, "It's not your profile! You can not change it.")
	|> redirect(to: user_path(conn, :show, user))
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    case Accounts.delete_user(conn.assigns.current_user, user) do
      {:ok, _user} ->
	conn
	|> put_flash(:info, "User deleted successfully.")
	|> redirect(to: user_path(conn, :index))
      {:error, :wrong_user} ->
	conn
	|> put_flash(:error, "It's not your profile! You can not delete it.")
	|> redirect(to: user_path(conn, :show, user))
    end
  end
end
