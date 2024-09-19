defmodule TinyChat.Chat do
  import Ecto.Query

  alias TinyChat.Repo
  alias TinyChat.Chat.Room

  def get_room(slug) when is_binary(slug) do
    from(room in Room, where: room.slug == ^slug)
    |> Repo.one()
  end
end
