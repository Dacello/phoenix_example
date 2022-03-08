defmodule Pokedex.Moves do
  import Ecto.Query

  alias Pokedex.{Move, PokemonMove, Repo}

  @default_preloads [:pokemon]

  def create_move!(params \\ %{}) do
    %Move{}
    |> Move.changeset(params)
    |> Repo.insert!()
  end

  def create_pokemon_move!(params \\ %{}) do
    %PokemonMove{}
    |> PokemonMove.changeset(params)
    |> Repo.insert!()
  end

  def list_moves(preloads \\ @default_preloads) do
    Move
    |> preload(^preloads)
    |> Repo.all()
  end
end
