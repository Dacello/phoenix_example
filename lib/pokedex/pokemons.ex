defmodule Pokedex.Pokemons do
  import Ecto.Query

  alias Pokedex.{Type, Pokemon, Repo}

  @default_preloads [:type, evolution: [:type, evolution: [:type]]]

  def get_pokemon(id, preloads \\ @default_preloads) do
    Pokemon
    |> Repo.get(id)
    |> Repo.preload(preloads)
  end

  def get_pokemon_by_name(name, preloads \\ @default_preloads) do
    Pokemon
    |> Repo.get_by(name: name)
    |> Repo.preload(preloads)
  end

  def create_pokemon(params) do
    %Pokemon{}
    |> Pokemon.changeset(params)
    |> Repo.insert()
  end

  def update_pokemon(pokemon, params) do
    pokemon
    |> Pokemon.changeset(params)
    |> Repo.update()
  end

  def create_pokemon_type(params) do
    %Type{}
    |> Type.changeset(params)
    |> Repo.insert()
  end
end
