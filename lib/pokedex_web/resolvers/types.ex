defmodule Pokedex.Resolvers.Types do
  use Pokedex.Resolvers.Resolver

  alias Pokedex.Types

  def list_types(_entity, _args, _context) do
    {:ok, Types.list_types()}
  end

  def get_type(_entity, %{name: name}, _context) do
    {:ok,
     name
     |> trim_string()
     |> Types.get_type_by_name()}
  end

  def get_type(_entity, %{id: id}, _context) do
    {:ok, Types.get_type(id)}
  end
end
