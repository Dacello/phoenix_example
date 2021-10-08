defmodule Example.Type do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.SoftDelete.Schema

  alias Example.{Pokemon, Type}

  @type t :: %__MODULE__{}
  schema "types" do
    field(:name, :string)
    field(:color, :string)

    belongs_to(:parent_type, Type)
    has_many(:pokemon, Pokemon)

    timestamps()
    soft_delete_schema()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [
      :name,
      :color,
    ])
  end
end
