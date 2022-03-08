defmodule Pokedex.Resolvers.Types do
  alias Pokedex.Types

  def list_types(_entity, _args, _context) do
    {:ok, Types.list_types()}
  end

  def get_type(_entity, %{name: name}, _context) do
    {:ok, Types.get_type_by_name(name)}
  end

  def get_type(_entity, %{id: id}, _context) do
    {:ok, Types.get_type(id)}
  end
end
