defmodule TinyChat.Repo do
  use Ecto.Repo,
    otp_app: :tiny_chat,
    adapter: Ecto.Adapters.Postgres
end
