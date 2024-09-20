defmodule TinyChat.Chat do
  import Ecto.Query

  alias TinyChat.Repo
  alias TinyChat.Chat.Room

  def create_room(%{"slug" => _, "title" => _} = params) do
    %Room{}
    |> Room.changeset(params)
    |> Repo.insert()
  end

  def get_room(slug) when is_binary(slug) do
    from(room in Room, where: room.slug == ^slug)
    |> Repo.one()
  end
end
