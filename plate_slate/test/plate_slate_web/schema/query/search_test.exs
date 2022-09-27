defmodule PlateSlateWeb.Schema.Query.SearchTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Data.seed()
  end

  test "given search query, when it's asking for MenuItems and Category, should return both at the same result" do
    # arrange
    query = """
      query($term: String!) {
        search(matching: $term){
          name
          __typename
        }
      }
    """

    variables = %{term: "e"}

    # act
    response =
      build_conn()
      |> get("/api", query: query, variables: variables)
      |> json_response(200)

    # assert
    assert %{"data" => %{"search" => results}} = response
    assert length(results) > 0
    assert Enum.find(results, &(&1["__typename"] == "Category"))
    assert Enum.find(results, &(&1["__typename"] == "MenuItem"))
    assert Enum.all?(results, &(&1["name"]))
  end
end
