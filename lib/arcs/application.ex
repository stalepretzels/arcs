defmodule Arcs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ArcsWeb.Telemetry,
      # Start the Ecto repository
      Arcs.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Arcs.PubSub},
      ArcsWeb.Presence,
      # Start the Endpoint (http/https)
      ArcsWeb.Endpoint
      # Start a worker by calling: Arcs.Worker.start_link(arg)
      # {Arcs.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arcs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArcsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
