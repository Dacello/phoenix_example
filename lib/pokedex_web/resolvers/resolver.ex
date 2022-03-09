defmodule Pokedex.Resolvers.Resolver do
  defmacro __using__(_opts) do
    quote do
      def trim_string(string) when is_binary(string) do
        string
        |> String.downcase()
        |> String.trim()
      end

      def trim_string(value), do: value
    end
  end
end
