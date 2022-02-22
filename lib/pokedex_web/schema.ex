defmodule PokedexWeb.Schema do
  use Absinthe.Schema

  alias Pokedex.{Pokemons}

  query do
    field :get_pokemon, :pokemon do
      arg(:id, :id)
      arg(:name, :string)

      resolve(fn
        _entity, %{id: id}, _context ->
          {:ok, Pokemons.get_pokemon(id)}

        _entity, %{name: name}, _context ->
          {:ok, Pokemons.get_pokemon_by_name(name)}
      end)
    end
  end

  object :pokemon do
    field :id, :id
    field :name, :string
    field :hp, :integer
    field :type, :type
  end

  object :type do
    field :id, :id
    field :name, :string
    field :color, :string
  end
end
