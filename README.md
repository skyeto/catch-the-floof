# Floofcatcher

Discord bot to handle menial CTF tasks such as creating channels, tracking challenges, etc.

## Getting Started
### Dev
0. Install Elixir, add PostgreSQL credentials and Discord token to `config/*.exs` 
1. `mix deps.get`
2. `mix ecto.create`
3. `mix ecto.migrate`
4. `mix phx.server` 

Inviting the bot to a server is as easy as going to `http://localhost/discord/add`