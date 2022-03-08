defmodule Pokedex.PokemonType do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Pokedex.{Pokemon, Type}

  @type t :: %__MODULE__{}

  schema "pokemon_types" do
    belongs_to(:pokemon, Pokemon)
    belongs_to(:type, Type)

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    cast(model, params, [:type_id, :pokemon_id])
  end
end
