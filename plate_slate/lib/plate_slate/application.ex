defmodule PlateSlate.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlateSlate.Repo,
      PlateSlateWeb.Telemetry,
      {Phoenix.PubSub, name: PlateSlate.PubSub},
      PlateSlateWeb.Endpoint,
      {Absinthe.Subscription, [PlateSlateWeb.Endpoint]}
    ]

    opts = [strategy: :one_for_one, name: PlateSlate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PlateSlateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
