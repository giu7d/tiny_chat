defmodule TinyChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TinyChatWeb.Telemetry,
      TinyChat.Repo,
      {DNSCluster, query: Application.get_env(:tiny_chat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TinyChat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TinyChat.Finch},
      # Start a worker by calling: TinyChat.Worker.start_link(arg)
      # {TinyChat.Worker, arg},
      # Start to serve requests, typically the last entry
      TinyChatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TinyChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TinyChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
