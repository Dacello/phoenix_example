# GraphQL in Elixir
When does it make sense to use GraphQL in Elixir?

- GraphQL is particularly great for exposing APIs to external systems/applications
- It was developed by Facebook as a solution to optimize data-fetching in mobile apps
- Although possible, doesnt seem like it makes a ton of sense to use GraphQL in Elixir for a simple Phoenix app
  - Phoenix apps come with LiveView nowadays, and that is more and more the direction we are headed w/ Phoenix web apps
  - LiveView has its own way of communicating with the server via websockets/phx channels
    - GraphQL is generally done using standard HTTP requests which conflicts with liveviews use of websockets
- Although there are a few GraphQL implementations in Elixir, [Absinthe](https://github.com/Absinthe-GraphQL/Absinthe) seems to have won out
  - Absinthe does not yet have a "client" library, although they've been talking about working on one for some time
  - I have a feeling they stopped work on Absinthe client because the phx community is so all in on LiveView
- Absinthe contributor Ben Wilson did [an episode with Thinking Elixir folks](https://podcast.thinkingelixir.com/2)
  - Thinking Elixir blog also has a [good post](https://thinkingelixir.com/rest-vs-GraphQL-for-an-api/) about it.
  - Ben discusses how his team's using GraphQL with LiveView, but he mentions that the GraphQL server is its own service. 
  - I haven't seen their implementation, but I can imagine that app that contains the LiveView is actually sending HTTP requests to the GraphQL server
  - Ben has also commented on [a post in the Elixir forum](https://elixirforum.com/t/anyone-using-a-Phoenix-LiveView-client-to-access-a-Phoenix-Absinthe-api/26614/10) where he mentions that they were able to do some cool stuff with LiveView and GraphQL subscriptions
    - Not sure how that was implemented; suspect it was not straightforward

## Building an GraphQL API in Elixir
This is a [good intro](https://www.howtographql.com/GraphQL-elixir/0-introduction/)

### The Gist
1. Set up a basic Phoenix app (`mix phx.new` or the like)
2. Install Absinthe and Absinthe-plug as elixir deps
3. Create a schema file that contains definitions for:
  - Datatypes
  - Queries
  - Mutations
4. Create resolver modules with functions that are referenced in your Schema
  - These will probably end up using Etco via standard Context functions under the hood 
5. Add GraphiQL endpoint to router for testing
```
scope "/graphiql" do
  forward "/", Absinthe.Plug.GraphiQL, schema: MyAppWeb.Schema
end
```
6. Once you have your schema/resolvers set up and tested using GraphiQL, expose a GraphQL API endpoint in your router using `Absinthe.Plug`
```
forward "/api", Absinthe.Plug, schema: MyAppWeb.Schema
```

## Demo!

### Background
A few years back, I did a [presentation](https://github.com/Dacello/graphql-prezo) and wrote a [blog post](https://revelry.co/insights/development/what-is-graphql/) on GraphQL. At the time, I was working on a project where we had just started playing around with GraphQL, but it was exclusively Javascript.

I hadn't gotten very deep into Elixir yet at the time, but I had heard of an Elixir implementation of GraphQL called "Absinthe", and I was curious to try it. I never got around to using it for that presentation (instead I used Node and Apollo, which is not a terrible experience, but **_Elixir_**). Since then, I _still_ haven't had any opportunities to create a GraphQL API in Elixir.

Lately, Ive been finding myself on projects that are using Elixir (YAY) but unfortunately not the shiniest newest stuff (e.g. PETAL stack w/ the latest LiveView). I decided that it would be good to play around with a fresh Phoenix app to try out all fun stuff people have been raving about. Initially this was primarily to get my feet wet with the PETAL stack, but I have since pivoted and am using this example app to play with Absinthe.

I was actually gonna see if I could do something with Absinthe in the PETAL stack, but it didnt take long for me to talk myself out of trying to figure out how the heck a LiveView + Absinthe stack would work.

**One thing at a time!**

So, instead of that, I decided to make my Phoenix Absinthe app simply be the GraphQL API, which I would expose to a React Native mobile app.

### The Dataset
I needed to have a good dataset with some reasonably complex associations in order to do anything interesting with GraphQL.
I decided to go with **Pokemon**, because:
  1. I recently picked the trading card game back up (its a huge money sink but lets not talk about that). Its been fun! Ask me about my decks :smirk: 
  2. The data relationships are actually pretty complex and figured itd a great dataset to show off what GraphQL is capable of.

I knew there must be some public API out there that I could use for this... and it turns out there is!

I found https://pokeapi.co/, which has a _ton_ of data; in fact way more than I want. 
Unfortunately, this API is really specific to the Pokemon video games (which are great, but I haven't played them since red/blue). I decided it would be good enough for now, at least for an example application (even if I might need a different dataset to make a deck building app that I might actually use IRL...)

Interestingly, PokeAPI offers both REST and GraphQL APIs. 

https://pokeapi.co/docs/v2
https://beta.pokeapi.co/GraphQL/console/

I played around with the GraphQL Graphiql interface for a _while_ and its pretty cool.
It makes really shows how complex all of that Pokemon data is...
### PokeAPI GraphQL Request examples
Here's an example of a query I tried with in the [PokeAPI GraphQL API](https://beta.pokeapi.co/graphql/console/):

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

Interestingly, once you start trying to query several levels of of nested associations,
The app starts freezing up / timing out pretty quick.
To be fair, the pokeapi GraphQL api is still in Beta.

They probably havent implemented any of these optimizations/protective measures:
- Size Limiting
- Query Whitelisting
- Depth Limiting
- Amount Limiting
- Query Cost Analysis 
- Caching

Their REST API seemed to be a bit more reliable, and also happened to have almost all the data I needed in the standard `/pokemon` GET request. 

Funny enough, there was one data point I needed that required an additional request for each pokemon (the `evolves_from_species_id`), because for some reason that wasnt available on the `/pokemon` endpoint, instead I had to hit the `/pokemon_species` endpoint...

This is a perfect example of REST requiring both **over-fetching** AND **under-fetching**.

At the same time their GraphQL API is a good example of how you can run into performance problems pretty quickly with GraphQL if you arent careful. 

**Regardless of the tech stack, you can and will eventually run into performance issues that will require intentional optimization and refactoring.**

---

_Anyway_... this presentation / demo is about GraphQL in _Elixir_, so I figured itd be OK to write my data import script using the PokeAPI REST API, and then just expose the data I stole via my own Elixir/Absinthe GraphQL API (Not to mention the shapes/names of their data hurts my heart). 

I decided to limit my dataset to the origin 151 pokemon, with the following data for each Pokemon:
- An Image
- Name
- Type(s) (e.g. Grass, Fire, Water, Psychic, Thunder, Dark, Normal)
- Moves
 - There is a ton of data that I could have captured for every move, but for simplicity sake I decided to just capture the names of each move


End result: https://github.com/Dacello/pokedex


### Consuming our new GraphQL API via a Mobile App
At first I was a little ambitious and wanted to try out Relay, a library that was also developed by Facebook to optimize Querying GraphQL in React. 
I think that if I were to actually build a real mobile app that communicated primarily with GraphQL, I would use Relay.
BUT it was a bit too much for me to figure out in time for this presentation, and its easy enough to just use standard HTTP requests without any extra libraries.
I havent used Relay on a real project before, but from what I read about it, it seems to provide some good optimizations around abstracting queries into composable fragments, allowing individual components to fetch only the data that they need to render. Or something like that.

Anyway, I went with a simple Expo app to make things easy
Sidenote: Man, Expo has gotten really nice to work with! I remember creating react native apps when it first started and it was not this easy or pleasant.


End result: https://github.com/Dacello/pokedex_mobile
