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

  def create_item(_, %{input: params}, _) do
    case MenuModel.create_item(params) do
      {:error, changeset} ->
        {:error, message: "Could not create menu item", details: error_details(changeset)}

      {:ok, _} = success ->
        success
    end
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
