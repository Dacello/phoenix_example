defmodule Pokedex.Pokemons do
  import Ecto.Query

  alias Pokedex.{Pokemon, Repo}

  @default_preloads [:types, :moves, evolves_from: [:types, :moves, :evolves_from]]

  def list_pokemon(preloads \\ @default_preloads) do
    Pokemon
    |> preload(^preloads)
    |> Repo.all()
  end

  def list_pokemon_by_type(type_name, preloads \\ @default_preloads)

  def list_pokemon_by_type("all", preloads), do: list_pokemon(preloads)

  def list_pokemon_by_type(type_name, preloads) do
    from(pokemon in Pokemon,
      inner_join: types in assoc(pokemon, :types),
      on: types.name == ^type_name,
      as: :types
    )
    |> preload(^preloads)
    |> Repo.all()
  end

  def get_pokemon(id, preloads \\ @default_preloads) do
    Pokemon
    |> preload(^preloads)
    |> Repo.get(id)
  end

  def get_pokemon_by_name(name, preloads \\ @default_preloads) do
    parsed_name =
      name
      |> String.downcase()
      |> String.trim()

    Pokemon
    |> preload(^preloads)
    |> Repo.get_by(name: parsed_name)
  end

  def create_pokemon!(params) do
    %Pokemon{}
    |> Pokemon.changeset(params)
    |> Repo.insert!()
  end

  def update_pokemon!(pokemon, params) do
    pokemon
    |> Pokemon.changeset(params)
    |> Repo.update!()
  end

  def update_pokemon(pokemon, params) do
    pokemon
    |> Pokemon.changeset(params)
    |> Repo.update()
  end
end
