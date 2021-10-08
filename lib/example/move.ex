defmodule Example.Move do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Example.{Pokemon}

  @type t :: %__MODULE__{}
  schema "moves" do
    field(:name, :string)
    field(:description, :string)
    field(:damage, :integer)

    belongs_to(:pokemon, Pokemon)

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :description,
      :damage,
      :pokemon_id
    ])
  end
end
