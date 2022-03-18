defmodule Pokedex.Resolvers.Pokemon do
  use Pokedex.Resolvers.Resolver

  alias Pokedex.{Pokemons, Pokemon}

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

  def capture_pokemon(_entity, %{id: id}, _context) do
    with %Pokemon{} = pokemon <- Pokemons.get_pokemon(id),
         {:ok, pokemon} <- Pokemons.update_pokemon(pokemon, %{captured_at: DateTime.utc_now()}) do
      {:ok, pokemon}
    else
      error ->
        {:error, "Couldn't capture pokemon"}
    end
  end

  def uncapture_pokemon(_entity, %{id: id}, _context) do
    with %Pokemon{} = pokemon <- Pokemons.get_pokemon(id),
         {:ok, pokemon} <- Pokemons.update_pokemon(pokemon, %{captured_at: nil}) do
      {:ok, pokemon}
    else
      error ->
        {:error, "Couldn't un-capture pokemon"}
    end
  end

  def get_pokemon(_entity, %{id: id}, _context) do
    {:ok, Pokemons.get_pokemon(id)}
  end
end
