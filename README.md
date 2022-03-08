# PokedEx
A Pokedex app in Elixir. Gotta catch em all and all that.

https://www.howtographql.com/graphql-elixir/0-introduction/


https://thinkingelixir.com/rest-vs-graphql-for-an-api/
https://podcast.thinkingelixir.com/2
https://github.com/absinthe-graphql/dataloader
https://github.com/absinthe-graphql/absinthe


### PokeAPI graphQL request examples
https://beta.pokeapi.co/graphql/console/
```
query samplePokeAPIquery {
  gen3_species: pokemon_v2_pokemonspecies(where: {evolves_from_species_id: {_is_null: true}}, order_by: {id: asc}) {
    id
    name
     pokemon_v2_pokemons {
      pokemon_v2_pokemontypes {
        pokemon_v2_type {
          name
        }
      }
    }
    pokemon_v2_evolutionchain {
      pokemon_v2_pokemonspecies(where: {evolves_from_species_id: {_is_null: false}}) {
        id
        name
        evolves_from_species_id
        pokemon_v2_pokemons {
          pokemon_v2_pokemontypes {
            pokemon_v2_type {
              name
            }
          }
        }
      }
    }
  }
}
```
```
query samplePokeAPIquery {
  gen3_species: pokemon_v2_pokemonspecies(limit: 151, order_by: {id: asc}) {
    id
    name
    evolves_from_species_id
    pokemon_v2_pokemons {
      pokemon_v2_pokemontypes {
        pokemon_v2_type {
          name
        }
      }
      pokemon_v2_pokemonsprites {
        sprites
      }
      pokemon_v2_pokemonmoves_aggregate(order_by: {level: asc}) {
        nodes {
          level
          pokemon_v2_move {
            id
            name
            power
            pp
          }
        }
      }
    }
  }
}
```
