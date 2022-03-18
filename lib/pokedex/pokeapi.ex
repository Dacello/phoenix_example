defmodule Pokedex.Pokeapi do
  alias Pokedex.{Pokemons, Types, Moves, Repo}

  @base_url "https://pokeapi.co/api/v2"
  @original_pokemon_count 151

  def run(dry_run? \\ true) do
    Repo.transaction(
      fn ->
        api_results =
          Enum.map(1..@original_pokemon_count, fn id ->
            %{body: pokemon_response} = HTTPoison.get!("#{@base_url}/pokemon/#{id}")
            %{body: species_response} = HTTPoison.get!("#{@base_url}/pokemon-species/#{id}")

            %{
              pokemon: Jason.decode!(pokemon_response),
              species: Jason.decode!(species_response)
            }
          end)

        types = create_types!(api_results)
        moves = create_moves!(api_results)
        pokemons = create_pokemons!(api_results)
        create_pokemon_moves!(api_results, pokemons, moves)
        create_pokemon_types!(api_results, pokemons, types)
        populate_evolves_from_ids!(api_results, pokemons)

        if dry_run? do
          Repo.rollback(:dry_run)
        end
      end,
      timeout: :infinity
    )
  end

  defp normalize_stats(stats) do
    Enum.reduce(stats, %{}, fn %{"base_stat" => value, "stat" => %{"name" => name}}, acc ->
      Map.put(acc, name, value)
    end)
  end

  defp get_image_url_from_pokemon_response(%{
         "sprites" => %{"other" => %{"official-artwork" => %{"front_default" => image_url}}}
       }),
       do: image_url

  defp get_image_url_from_pokemon_response(%{
         "sprites" => %{"other" => %{"front_detault" => image_url}}
       }),
       do: image_url

  defp get_image_url_from_pokemon_response(_), do: nil

  def create_types!(api_results) do
    api_results
    |> Enum.flat_map(&Map.get(&1[:pokemon], "types"))
    |> Enum.uniq_by(& &1["type"]["name"])
    |> Enum.map(&create_type!/1)
  end

  defp create_type!(%{"type" => %{"name" => name}}), do: Types.create_type!(%{name: name})

  def create_moves!(api_results) do
    api_results
    |> Enum.flat_map(&Map.get(&1[:pokemon], "moves"))
    |> Enum.uniq_by(& &1["move"]["name"])
    |> Enum.map(&create_move!/1)
  end

  defp create_move!(%{"move" => %{"name" => name, "url" => "#{@base_url}/move/" <> pokeapi_path}}) do
    pokeapi_id =
      pokeapi_path
      |> String.replace("/", "")
      |> String.to_integer()

    Moves.create_move!(%{name: name, pokeapi_id: pokeapi_id})
  end

  def create_pokemons!(api_results) do
    Enum.map(api_results, fn %{pokemon: pokemon} ->
      Pokemons.create_pokemon!(%{
        name: pokemon["name"],
        pokeapi_id: pokemon["id"],
        stats: normalize_stats(pokemon["stats"]),
        image_url: get_image_url_from_pokemon_response(pokemon)
      })
    end)
  end

  defp create_pokemon_moves!(api_results, pokemons, moves) do
    Enum.map(api_results, fn %{pokemon: %{"name" => pokemon_name, "moves" => pokemon_moves}} ->
      %{id: pokemon_id} = Enum.find(pokemons, &(&1.name == pokemon_name))

      pokemon_moves
      |> Enum.map(fn %{"move" => %{"name" => move_name}} ->
        %{id: move_id} = Enum.find(moves, &(&1.name == move_name))

        Moves.create_pokemon_move!(%{pokemon_id: pokemon_id, move_id: move_id})
      end)
    end)
  end

  defp create_pokemon_types!(api_results, pokemons, types) do
    Enum.map(api_results, fn %{pokemon: %{"name" => pokemon_name, "types" => pokemon_types}} ->
      %{id: pokemon_id} = Enum.find(pokemons, &(&1.name == pokemon_name))

      pokemon_types
      |> Enum.map(fn %{"type" => %{"name" => type_name}} ->
        %{id: type_id} = Enum.find(types, &(&1.name == type_name))

        Types.create_pokemon_type!(%{pokemon_id: pokemon_id, type_id: type_id})
      end)
    end)
  end

  defp populate_evolves_from_ids!(api_results, pokemons) do
    Enum.map(
      api_results,
      fn
        %{
          species: %{"evolves_from_species" => %{"name" => evolves_from_name}},
          pokemon: %{"name" => pokemon_name}
        } ->
          case Enum.find(pokemons, &(&1.name == evolves_from_name)) do
            %{id: evolves_from_id} ->
              pokemon_to_update = Enum.find(pokemons, &(&1.name == pokemon_name))

              Pokemons.update_pokemon!(pokemon_to_update, %{evolves_from_id: evolves_from_id})

            _ ->
              IO.inspect(evolves_from_name, label: "Couldn't find pokemon to set evolves from id")

              nil
          end

        _ ->
          nil
      end
    )
  end
end
