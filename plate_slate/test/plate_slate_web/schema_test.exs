# ---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
# ---
defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Data.seed()
  end

  describe "query menu-items/0" do
    test "menuItems field returns menu items" do
      # arrange
      query = """
      {
        menuItems {
          name
        }
      }
      """

      # act
      response =
        build_conn()
        |> get("/api", query: query)
        |> json_response(200)

      # assert
      expected_response = %{
        "data" => %{
          "menuItems" => [
            %{"name" => "Reuben"},
            %{"name" => "Croque Monsieur"},
            %{"name" => "Muffuletta"},
            %{"name" => "Bánh mì"},
            %{"name" => "Vada Pav"},
            %{"name" => "French Fries"},
            %{"name" => "Papadum"},
            %{"name" => "Pasta Salad"},
            %{"name" => "Water"},
            %{"name" => "Soft Drink"},
            %{"name" => "Lemonade"},
            %{"name" => "Masala Chai"},
            %{"name" => "Vanilla Milkshake"},
            %{"name" => "Chocolate Milkshake"}
          ]
        }
      }

      assert response == expected_response
    end
  end

  describe "query menu_items/1" do
    test "given query, when has `matching` filter, should filter by the value" do
      # arrange
      query = """
        {
          menuItems(matching: "reu") {
            name
          }
        }
      """

      # act
      response =
        build_conn()
        |> get("/api", query: query)
        |> json_response(200)

      # assert
      expected_response = %{"data" => %{"menuItems" => [%{"name" => "Reuben"}]}}
      assert response == expected_response
    end

    test "given query, when has `matching` with non string value, should return error" do
      # arrange
      query = """
      {
        menuItems(matching: 123) {
          name
        }
      }
      """

      # act
      response =
        build_conn()
        |> get("/api", query: query)
        |> json_response(200)

      # assert
      expected_response = %{
        "errors" => [
          %{
            "locations" => [%{"column" => 13, "line" => 2}],
            "message" => "Argument \"matching\" has invalid value 123."
          }
        ]
      }

      assert response == expected_response
    end
  end
end
