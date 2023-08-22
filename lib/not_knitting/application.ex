defmodule NotKnitting.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NotKnittingWeb.Telemetry,
      # Start the Ecto repository
      NotKnitting.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NotKnitting.PubSub},
      # Start Finch
      {Finch, name: NotKnitting.Finch},
      # Start the Endpoint (http/https)
      NotKnittingWeb.Endpoint
      # Start a worker by calling: NotKnitting.Worker.start_link(arg)
      # {NotKnitting.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NotKnitting.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotKnittingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
