defmodule Test1.Events.Event do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset


  schema "events" do
    field :address, :string
    field :city, :string
    field :cover, Test1.ImageUploader.Type
    field :date, :naive_datetime
    field :description, :string
    field :link, :string
    field :title, :string
    #field :organizer, :id

    belongs_to :user, Test1.Accounts.User, foreign_key: :organizer

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :city, :description, :date, :cover, :address, :link])
    |> cast_attachments(attrs, [:cover])
    |> validate_required([:title, :city, :description, :date, :cover, :address, :link])
  end
end
