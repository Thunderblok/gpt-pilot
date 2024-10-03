defmodule Oko.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OkoWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:oko, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Oko.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Oko.Finch},
      # Start a worker by calling: Oko.Worker.start_link(arg)
      # {Oko.Worker, arg},
      # Start to serve requests, typically the last entry
      OkoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Oko.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OkoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
