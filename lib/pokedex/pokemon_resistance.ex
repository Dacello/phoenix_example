defmodule Pokedex.PokemonResistance do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Pokedex.{Type, Pokemon}

  @type t :: %__MODULE__{}
  schema "pokemon_resistances" do
    belongs_to(:type, Type)
    belongs_to(:pokemon, Pokemon)

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :hp,
      :evolution_id,
      :type_id
    ])
  end
end
