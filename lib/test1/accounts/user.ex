defmodule Test1.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :bio, :string
    field :email, :string
    field :name, :string
    field :password, :string

    has_many :events, Test1.Events.Event, foreign_key: :organizer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :bio, :password])
    |> validate_required([:name, :email, :bio, :password])
  end
end
