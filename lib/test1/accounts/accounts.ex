defmodule Test1.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Test1.Repo

  alias Test1.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> preload(:events)
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    User
    |> preload(:events)
    |> Repo.get!(id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the current user. If trying to update different user
  `{:error, :wrong_user}` is returned.

  ## Examples

      iex> update_user(current_user, user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(current_user, user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> update_user(current_user, different_user, %{field: bad_value})
      {:error, :wrong_user}

  """
  def update_user(%User{} = current_user, %User{} = user, attrs) do
    case user do
      ^current_user ->
	user
	|> User.changeset(attrs)
	|> Repo.update()
      _ ->
	{:error, :wrong_user}
    end
  end

  @doc """
  Deletes the current user with all its data (events).

  If trying to delete a different user, `{:error, :wrong_user}`
  is returned.

  ## Examples

      iex> delete_user(current_user, user)
      {:ok, %User{}}

      iex> delete_user(current_user, user)
      {:error, %Ecto.Changeset{}}

      iex> delete_user(current_user, different_user)
      {:error, :wrong_user}

  """
  def delete_user(%User{} = current_user, %User{} = user) do
    case user do
      ^current_user ->
	user
	|> Repo.delete()
      _ ->
	{:error, :wrong_user}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = current_user, %User{} = user) do
    case user do
      ^current_user ->
	changeset = User.changeset(user, %{})
	{:ok, changeset}
      _ ->
	{:error, :wrong_user}
    end
  end

  @doc """
  Checks if user input (email and password pair) are valid.

  Is used to authorise a user session.
  """
  @spec authenticate_by_email_password(String.t, String.t) :: %User{} | nil
  def authenticate_by_email_password(email, password) do
    User
    |> where([u], u.email == ^email and u.password == ^password)
    |> Repo.one
    |> case do
	 %User{} = user -> {:ok, user}
	 nil -> {:error, :unauthorized}
       end
  end
end
