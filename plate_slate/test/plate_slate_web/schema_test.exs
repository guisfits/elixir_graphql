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

  describe "query menu-items" do
    test "given query, without any params, should return all items" do
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
            %{"name" => "Bánh mì"},
            %{"name" => "Chocolate Milkshake"},
            %{"name" => "Croque Monsieur"},
            %{"name" => "French Fries"},
            %{"name" => "Lemonade"},
            %{"name" => "Masala Chai"},
            %{"name" => "Muffuletta"},
            %{"name" => "Papadum"},
            %{"name" => "Pasta Salad"},
            %{"name" => "Reuben"},
            %{"name" => "Soft Drink"},
            %{"name" => "Vada Pav"},
            %{"name" => "Vanilla Milkshake"},
            %{"name" => "Water"}
          ]
        }
      }

      assert response == expected_response
    end

    test "given query, when it's has ordering, should return items ordered" do
      # arrange
      query = """
      {
        menuItems(order: DESC) {
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
            %{"name" => "Water"},
            %{"name" => "Vanilla Milkshake"},
            %{"name" => "Vada Pav"},
            %{"name" => "Soft Drink"},
            %{"name" => "Reuben"},
            %{"name" => "Pasta Salad"},
            %{"name" => "Papadum"},
            %{"name" => "Muffuletta"},
            %{"name" => "Masala Chai"},
            %{"name" => "Lemonade"},
            %{"name" => "French Fries"},
            %{"name" => "Croque Monsieur"},
            %{"name" => "Chocolate Milkshake"},
            %{"name" => "Bánh mì"}
          ]
        }
      }

      assert response == expected_response
    end

    test "given query, when has filters, should filter by those values" do
      # arrange
      query = """
        {
          menuItems(filter: {category: "Sandwiches", tag: "Vegetarian"}) {
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
      expected_response = %{"data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}}
      assert response == expected_response
    end

    test "given query, when has filter from a variable, should filter by the variable values" do
      # arrange
      query = """
      query($filter: MenuItemFilter!){
        menuItems(filter: $filter) {
          name
        }
      }
      """

      variables = %{filter: %{"tag" => "Vegetarian", "category" => "Sandwiches"}}

      # act
      response =
        build_conn()
        |> get("/api", query: query, variables: variables)
        |> json_response(200)

      # assert
      expected_response = %{"data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}}
      assert response == expected_response
    end

    test "given query, when has invalid filter, should return error" do
      # arrange
      query = """
      {
        menuItems(filter: 123) {
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
            "message" => "Argument \"filter\" has invalid value 123."
          }
        ]
      }

      assert response == expected_response
    end
  end
end
