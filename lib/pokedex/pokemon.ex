defmodule Pokedex.Pokemon do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Pokedex.{Pokemon, PokemonMove, PokemonType}

  @type t :: %__MODULE__{}
  schema "pokemons" do
    field(:name, :string)
    field(:image_url, :string)
    field(:pokeapi_id, :integer)
    field(:stats, :map)
    field(:captured_at, :utc_datetime_usec)

    belongs_to(:evolves_from, Pokemon)

    has_many(:pokemon_moves, PokemonMove)
    has_many(:moves, through: [:pokemon_moves, :move])
    has_many(:pokemon_types, PokemonType)
    has_many(:types, through: [:pokemon_types, :type])

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :stats,
      :image_url,
      :captured_at,
      :pokeapi_id,
      :evolves_from_id
    ])
    |> unique_constraint(:name)
  end
end
