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

  mutation do
    @desc "Mark a Pokemon as captured"
    field :capture_pokemon, :pokemon do
      arg :id, non_null(:id)

      resolve &Resolvers.Pokemon.capture_pokemon/3
    end

    @desc "Unmark a Pokemon as captured"
    field :uncapture_pokemon, :pokemon do
      arg :id, non_null(:id)

      resolve &Resolvers.Pokemon.uncapture_pokemon/3
    end
  end


  object :pokemon do
    field :id, :id
    field :name, :string
    field :image_url, :string
    field :evolves_from, :pokemon
    field :captured_at, :string
    field :types, list_of(:type)
    field :moves, list_of(:move)
  end

  object :type do
    field :id, :id
    field :name, :string
    field :pokemon, list_of(:pokemon)
  end

  object :move do
    field :id, :id
    field :name, :string
    field :pokemon, list_of(:pokemon)
  end
end
