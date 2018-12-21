defmodule Test1.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Test1.Repo

  alias Test1.Events.Event
  alias Test1.Accounts.User

  @doc """
  Returns the list of events with its user info.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Event
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single event with its user info.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id) do
    Event
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a event for the current user.

  ## Examples

      iex> create_event(user, %{field: value})
      {:ok, %Event{}}

      iex> create_event(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(%User{} = user, attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Ecto.Changeset.put_change(:organizer, user.id)
    |> Repo.insert()
  end

  @doc """
  Updates a event checking if the current user is allowed to do so.

  ## Examples

      iex> update_event(user, event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(user, event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> update_event(wrong_user, event, %{field: new_value})
      {:error, :wrong_user}

  """
  def update_event(%User{id: user_id} = user, %Event{} = event, attrs) do
    case event.user.id do
      ^user_id ->
	event
	|> Event.changeset(attrs)
	|> Ecto.Changeset.put_change(:organizer, user.id)
	|> Repo.update()
      _ ->
	{:error, :wrong_user}
    end
  end

  @doc """
  Deletes an Event if the current user is allowed to do so.

  ## Examples

      iex> delete_event(user, event)
      {:ok, %Event{}}

      iex> delete_event(user, event)
      {:error, %Ecto.Changeset{}}

      iex> delete_event(wrong_user, event)
      {:error, :wrong_user}

  """
  def delete_event(%User{id: user_id} = user, %Event{} = event) do
    case event.user.id do
      ^user_id ->
	Repo.delete(event)
      _ ->
	{:error, :wrong_user}
    end
  end

  @doc """
  Returns an `{:ok, %Ecto.Changeset{}}` for tracking event changes if
  the current user is allowed to change it. Returns `{:error, :wrong_user}`
  otherwise.

  ## Examples

      iex> change_event(user, event)
      {:ok, %Ecto.Changeset{source: %Event{}}}

      iex> change_event(wrong_user, event)
      {:error, :wrong_user}

  """
  def change_event(%User{id: user_id} = user, %Event{} = event) do
    case event.user.id do
      ^user_id ->
	changeset = Event.changeset(event, %{})
	{:ok, changeset}
      _ ->
	{:error, :wrong_user}
    end
  end
end
