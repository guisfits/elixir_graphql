# ---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
# ---
defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.Resolvers.Menu, as: MenuResolver

  import_types(__MODULE__.Types.Menu)
  import_types(__MODULE__.Types.Shared)

  query do
    @desc "get menu items"
    field :menu_items, list_of(:menu_item) do
      arg(:filter, :menu_item_filter)
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(&MenuResolver.menu_items/3)
    end

    @desc "search for category or menu_items"
    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)
      resolve(&MenuResolver.search/3)
    end
  end
end
