defmodule Pokedex.Repo.Migrations.AddDataToMoves do
  use Ecto.Migration

  def change do
    alter table(:moves) do
      add :power, :integer
      add :pp, :integer
      add :accuracy, :integer
      add :damage_class, :string
      add :effects, :map
    end
  end
end
