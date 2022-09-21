defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu, as: MenuModel

  def menu_items(_, args, _) do
    {:ok, MenuModel.list_items(args)}
  end
end
