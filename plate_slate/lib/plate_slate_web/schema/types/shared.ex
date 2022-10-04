defmodule PlateSlateWeb.Schema.Types.Shared do
  use Absinthe.Schema.Notation

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  scalar :date do
    parse(fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
           {:ok, date} <- Date.from_iso8601(value) do
        {:ok, date}
      else
        _ -> :error
      end
    end)

    serialize(fn date ->
      Date.to_iso8601(date)
    end)
  end

  scalar :decimal do
    parse(fn
      %{value: value}, _ ->
        Decimal.parse(value)
        |> case do
          {decimal, _} ->
            {:ok, decimal}

          :error ->
            :error
        end

      _, _ ->
        :error
    end)

    serialize(&to_string/1)
  end
end
