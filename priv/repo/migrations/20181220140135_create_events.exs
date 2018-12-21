defmodule Test1.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :city, :string, null: false
      add :description, :string, null: false
      add :date, :naive_datetime, null: false
      add :cover, :string
      add :address, :string, null: false
      add :link, :string
      add :organizer, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:events, [:organizer, :city])
  end
end
