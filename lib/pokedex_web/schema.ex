defmodule PokedexWeb.Schema do
  use Absinthe.Schema

  alias Pokedex.Resolvers

  query do
    field :list_pokemon, list_of(:pokemon) do
      arg(:type, :string)

      resolve(&Resolvers.Pokemon.list_pokemon/3)
    end

    field :get_pokemon, :pokemon do
      arg(:id, :id)
      arg(:name, :string)

      resolve(&Resolvers.Pokemon.get_pokemon/3)
    end

    field :list_types, list_of(:type) do
      resolve(&Resolvers.Types.list_types/3)
    end

    field :get_type, :type do
      arg(:id, :id)
      arg(:name, :string)

      resolve(&Resolvers.Types.get_type/3)
    end
  end

  object :pokemon do
    field :id, :id
    field :name, :string
    field :evolves_from, :pokemon
    field :types, list_of(:type)
    field :moves, list_of(:move)
  end

  object :type do
    field :id, :id
    field :name, :string
  end

  object :move do
    field :id, :id
    field :name, :string
  end
end
