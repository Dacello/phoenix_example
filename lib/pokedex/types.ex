defmodule Pokedex.Types do
  import Ecto.Query

  alias Pokedex.{Type, PokemonType, Repo}

  @default_preloads [pokemon: [:moves]]

  def create_type!(params) do
    %Type{}
    |> Type.changeset(params)
    |> Repo.insert!()
  end

  def create_pokemon_type!(params \\ %{}) do
    %PokemonType{}
    |> PokemonType.changeset(params)
    |> Repo.insert!()
  end

  def list_types(preloads \\ @default_preloads) do
    Type
    |> preload(^preloads)
    |> Repo.all()
  end

  def get_type(id, preloads \\ @default_preloads) do
    Type
    |> preload(^preloads)
    |> Repo.get()
  end

  def get_type_by_name(name, preloads \\ @default_preloads) do
    parsed_name =
      name
      |> String.downcase()
      |> String.trim()

    Type
    |> preload(^preloads)
    |> Repo.get_by(name: name)
  end
end
