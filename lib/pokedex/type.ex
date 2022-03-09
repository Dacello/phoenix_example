defmodule Pokedex.Type do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Pokedex.{PokemonType}

  @type t :: %__MODULE__{}
  schema "types" do
    field(:name, :string)

    has_many(:pokemon_types, PokemonType)
    has_many(:pokemon, through: [:pokemon_types, :pokemon])

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name])
    |> unique_constraint(:name)
  end
end
