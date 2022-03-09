defmodule Pokedex.Resolvers.Pokemon do
  use Pokedex.Resolvers.Resolver

  alias Pokedex.Pokemons

  def list_pokemon(_entity, %{type: type}, _context) do
    {:ok, Pokemons.list_pokemon_by_type(type)}
  end

  def list_pokemon(_entity, _args, _context) do
    {:ok, Pokemons.list_pokemon()}
  end

  def get_pokemon(_entity, %{name: name}, _context) do
    {:ok,
     name
     |> trim_string()
     |> Pokemons.get_pokemon_by_name()}
  end

  def get_pokemon(_entity, %{id: id}, _context) do
    {:ok, Pokemons.get_pokemon(id)}
  end
end
