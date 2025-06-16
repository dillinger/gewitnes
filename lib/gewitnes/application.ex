defmodule Gewitnes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Gewitnes.Dogmatix.start_link("localhost", 8126)

    children = [
      GewitnesWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:gewitnes, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Gewitnes.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Gewitnes.Finch},
      # Start a worker by calling: Gewitnes.Worker.start_link(arg)
      # {Gewitnes.Worker, arg},
      # Start to serve requests, typically the last entry
      GewitnesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gewitnes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GewitnesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
