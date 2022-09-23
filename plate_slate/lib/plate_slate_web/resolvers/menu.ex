defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu, as: MenuModel

  def menu_items(_, args, _) do
    {:ok, MenuModel.list_items(args)}
  end

  def items_for_category(category, _, _) do
    query = Ecto.assoc(category, :items)
    {:ok, PlateSlate.Repo.all(query)}
  end

  def search(_, %{matching: term}, _) do
    {:ok, MenuModel.search(term)}
  end
end
