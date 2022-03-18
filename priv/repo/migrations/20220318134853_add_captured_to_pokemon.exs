defmodule Pokedex.Repo.Migrations.AddCapturedAtToPokemon do
  use Ecto.Migration

  def change do
    alter table(:pokemons) do
      add :captured_at, :utc_datetime_usec
    end
  end
end
