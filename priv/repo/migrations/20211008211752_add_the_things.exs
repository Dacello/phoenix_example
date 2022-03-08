defmodule Pokedex.Repo.Migrations.AddTheThings do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:types) do
      add(:name, :string)
<<<<<<< HEAD
      add(:color, :string)
      add(:parent_type_id, references(:types), on_delete: :nothing)
=======
>>>>>>> f34e35f03104927cadb2b1d3de22f8c496da9471

      soft_delete_columns()
      timestamps()
    end

    create table(:type_weaknesses) do
      add(:type_id, references(:types), on_delete: :nothing)
      add(:weakness_id, references(:types), on_delete: :nothing)

      soft_delete_columns()
      timestamps()
    end

    create table(:type_resistances) do
      add(:type_id, references(:types), on_delete: :nothing)
      add(:resistance_id, references(:types), on_delete: :nothing)

      soft_delete_columns()
      timestamps()
    end

    create table(:pokemons) do
      add(:name, :string)
<<<<<<< HEAD
      add(:hp, :integer)
      add(:type_id, references(:types), on_delete: :nothing)
      add(:evolution_id, references(:pokemons), on_delete: :nothing)
=======
      add(:stats, :map)
      add(:pokeapi_id, :integer)
      add(:image_url, :string)
      add(:evolves_from_id, references(:pokemons), on_delete: :nothing)

      soft_delete_columns()
      timestamps()
    end

    create table(:pokemon_types) do
      add(:type_id, references(:types), on_delete: :nothing)
      add(:pokemon_id, references(:pokemons), on_delete: :nothing)
>>>>>>> f34e35f03104927cadb2b1d3de22f8c496da9471

      soft_delete_columns()
      timestamps()
    end

    create table(:moves) do
      add(:name, :string)
      add(:damage, :integer)
<<<<<<< HEAD
      add(:description, :string)

      add(:pokemon_id, references(:pokemons), on_delete: :nothing)
=======
      add(:effect, :string)
      add(:description, :string)
      add(:pokeapi_id, :integer)
      add(:type_id, references(:types), on_delete: :nothing)

      soft_delete_columns()
      timestamps()
    end

    create table(:pokemon_moves) do
      add(:pokemon_id, references(:pokemons), on_delete: :nothing)
      add(:move_id, references(:moves), on_delete: :nothing)
>>>>>>> f34e35f03104927cadb2b1d3de22f8c496da9471

      soft_delete_columns()
      timestamps()
    end
<<<<<<< HEAD
=======

    create unique_index(:types, [:name], where: "deleted_at IS NULL")
    create unique_index(:moves, [:name], where: "deleted_at IS NULL")
    create unique_index(:pokemons, [:name], where: "deleted_at IS NULL")
    create unique_index(:pokemon_moves, [:pokemon_id, :move_id], where: "deleted_at IS NULL")
    create unique_index(:pokemon_types, [:pokemon_id, :type_id], where: "deleted_at IS NULL")
    create unique_index(:type_weaknesses, [:type_id, :weakness_id], where: "deleted_at IS NULL")

    create unique_index(:type_resistances, [:type_id, :resistance_id], where: "deleted_at IS NULL")
>>>>>>> f34e35f03104927cadb2b1d3de22f8c496da9471
  end
end
