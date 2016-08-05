defmodule TodoApi.Repo.Migrations.AddOwnerIdToTodos do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add :complete, :boolean, default: false, null: false
      add :owner_id, references(:users), null: false
    end
  end
end
