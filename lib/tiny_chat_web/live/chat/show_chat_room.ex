defmodule TinyChatWeb.Chat.ShowChatRoom do
  use TinyChatWeb, :live_view

  alias TinyChat.Chat
  alias TinyChat.Chat.Room

  def render(assigns) do
    ~H"""
    <.container>
      <.container_subtitle text="Chat Room" />
      <.container_title text={@room.title} />
    </.container>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    case Chat.get_room(slug) do
      %Room{} = room ->
        {:ok, assign(socket, :room, room)}

      _ ->
        {:ok, redirect(socket, to: "/")}
    end
  end
end
