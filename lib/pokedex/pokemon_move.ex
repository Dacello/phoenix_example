defmodule Pokedex.PokemonMove do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Pokedex.{Pokemon, Move}

  @type t :: %__MODULE__{}

  schema "pokemon_moves" do
    belongs_to(:pokemon, Pokemon)
    belongs_to(:move, Move)

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    cast(model, params, [:move_id, :pokemon_id])
  end
end
