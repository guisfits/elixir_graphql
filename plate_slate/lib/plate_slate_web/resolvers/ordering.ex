defmodule PlateSlateWeb.Resolvers.Ordering do
  alias PlateSlate.Ordering

  def place_order(_, %{input: place_order_input}, _) do
    case Ordering.create_order(place_order_input) do
      {:error, changeset} ->
        {:error, message: "Could not create menu item", details: error_details(changeset)}

      {:ok, order} ->
        order
    end
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
