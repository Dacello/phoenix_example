defmodule Pokedex.Move do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Pokedex.{PokemonMove, Type}

  @type t :: %__MODULE__{}
  schema "moves" do
    field(:name, :string)
    field(:description, :string)
    field(:pokeapi_id, :integer)
    field(:pp, :integer)
    field(:power, :integer)
    field(:accuracy, :integer)
    field(:damage_class, :string)
    field(:effects, {:array, :map})

    has_many(:pokemon_moves, PokemonMove)
    has_many(:pokemon, through: [:pokemon_moves, :pokemon])

    belongs_to(:type, Type)

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :description,
      :type_id,
      :pokeapi_id,
      :pp,
      :power,
      :accuracy,
      :damage_class,
      :effects
    ])
    |> unique_constraint(:name)
  end
end
