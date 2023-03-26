defmodule TestElixirFlyio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    app_name = :test_elixir_flyio

    topologies = [
      fly6pn: [
        strategy: Cluster.Strategy.DNSPoll,
        config: [
          polling_interval: 5_000,
          query: "#{app_name}.internal",
          node_basename: app_name
        ]
      ]
    ]

    children = [
      # Start the Ecto repository
      TestElixirFlyio.Repo,
      # Start the Telemetry supervisor
      TestElixirFlyioWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TestElixirFlyio.PubSub},
      # Start the Endpoint (http/https)
      TestElixirFlyioWeb.Endpoint,
      # Start a worker by calling: TestElixirFlyio.Worker.start_link(arg)
      # {TestElixirFlyio.Worker, arg}
      # setup for clustering
      {Cluster.Supervisor, [topologies, [name: TestElixirFlyio.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TestElixirFlyio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TestElixirFlyioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
