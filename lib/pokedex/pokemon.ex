defmodule Pokedex.Pokemon do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Pokedex.{Pokemon, Type}

  @type t :: %__MODULE__{}
  schema "pokemons" do
    field(:name, :string)
    field(:hp, :integer)

    belongs_to(:type, Type)
    belongs_to(:evolution, Pokemon)

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
