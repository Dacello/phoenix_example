# GraphQL in Elixir
When does it make sense to use GraphQL in Elixir?

## Building an GraphQL API in Elixir


### Background
A few years back, I did a presentation on GraphQL. At the time, I was working on a project called "AutoFi", and we had just started playing around with using GraphQL there (AutoFi used JS exclusively).
I hadn't gotten too deep into elixir yet at the time, but I did note that there was an Elixir implementation of GraphQL called "Absinthe", and I was curious to try it. I never got around to using it for that presentation, and since then there really haven't been any opportunities to create a graphql api in elixir.

So, recently I decided I would try out absinthe on a hobby project, with the hopes of using it for this presentation and maybe even some #content.


### The Dataset
I needed to have a good dataset with some reasonably complex associations so we can get the most out of GraphQL.
I decided to go with Pokemon, since:
  1. I recently picked the card game back up and its been fun 
  2. The data relationships are actually pretty complex and will be great for showing what GraphQL has to offer

So, I created https://github.com/Dacello/pokedex.

Off the bat, I knew there must be some API out there that I could grab all the data I would need.
I found https://pokeapi.co/, which has a _lot_ of data; in fact a lot more than I care to mess with right now. 
Unfortunately, the data from this API really specific to the pokemon video games (which are great, but I haven't played them since red/blue)
But I decided it would be good enough for now, at least for an example application.

Interestingly, this API offers both REST and GraphQL APIs. 

https://pokeapi.co/docs/v2
https://beta.pokeapi.co/graphql/console/

I played around with the graphql Graphiql interface for a _while_ and its pretty cool.
It makes really shows how complex all of that pokemon data is...
However, once you start trying to query several levels of of nested associations,
The app starts freezing up / timing out pretty quick.
To be fair, the pokeapi graphql api is still in Beta (for who knows how long)
They probably havent implemented any of these:
- Size Limiting
- Query Whitelisting
- Depth Limiting
- Amount Limiting
- Query Cost Analysis
Probably arent caching requests either...

Their REST API seemed to be a bit more reliable, and also happened to have almost all the data I needed in the standard pokemon GET request. 
Interestingly, there was one data point I needed that required an additional request to get (the evolves from pookemon id), because for some reason that wasnt available on the `pokemon` endpoint, instead I had to hit the `pokemon_species` endpoint...

A good example of REST requiring both over-fetching AND under-fetching at the same time.
That said, it still worked for my purposes even if it isnt the most performant.


So, now that I had data in my system, it was time to expose that via a graphQL API.


https://elixirforum.com/t/anyone-using-a-phoenix-liveview-client-to-access-a-phoenix-absinthe-api/26614/10

https://docs.expo.dev/guides/using-graphql/
