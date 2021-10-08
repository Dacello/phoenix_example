defmodule Example.Repo.Migrations.AddTheThings do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:types) do
      add(:name, :string)
      add(:color, :string)
      add(:parent_type, references(:types), on_delete: :nothing)

      soft_delete_columns()
    end

    create table(:type_weaknesses) do
      add(:type_id, references(:types), on_delete: :nothing)
      add(:weakness_id, references(:types), on_delete: :nothing)

      soft_delete_columns()
    end

    create table(:type_resistances) do
      add(:type_id, references(:types), on_delete: :nothing)
      add(:resistance_id, references(:types), on_delete: :nothing)

      soft_delete_columns()
    end

    create table(:pokemons) do
      add(:name, :string)
      add(:hp, :integer)
      add(:type_id, references(:types), on_delete: :nothing)
      add(:evolution_id, references(:pokemons), on_delete: :nothing)

      soft_delete_columns()
    end

    create table(:moves) do
      add(:name, :string)
      add(:damage, :integer)
      add(:description, :string)

      add(:pokemon_id, references(:pokemons), on_delete: :nothing)

      soft_delete_columns()
    end
  end
end
