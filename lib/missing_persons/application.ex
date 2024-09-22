defmodule MissingPersons.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MissingPersonsWeb.Telemetry,
      MissingPersons.Repo,
      {DNSCluster, query: Application.get_env(:missing_persons, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MissingPersons.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MissingPersons.Finch},
      # Start a worker by calling: MissingPersons.Worker.start_link(arg)
      # {MissingPersons.Worker, arg},
      # Start to serve requests, typically the last entry
      MissingPersonsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MissingPersons.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MissingPersonsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
