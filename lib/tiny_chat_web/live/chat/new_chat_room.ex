defmodule TinyChatWeb.Chat.NewChatRoom do
  use TinyChatWeb, :live_view

  alias TinyChat.Chat
  alias TinyChat.Chat.Room

  def render(assigns) do
    ~H"""
    <.container_illustration />
    <.container>
      <main>
        <.simple_form for={@form} phx-change="validate" phx-submit="save">
          <.container_subtitle text="Tiny Chat" />
          <.container_title text="New Room" />
          <.container_description text="Create a new room to start chatting with your friends." />

          <.input label="Room Name" field={@form[:title]} />
          <.input label="Room ID" field={@form[:slug]} />

          <:actions>
            <.button>Create</.button>
          </:actions>
        </.simple_form>
      </main>
    </.container>
    """
  end

  def mount(params, _session, socket) do
    form =
      %Room{}
      |> Room.changeset(params)
      |> to_form()

    {:ok, assign(socket, form: form)}
  end

  def handle_event("validate", %{"room" => room_params}, socket) do
    form =
      %Room{}
      |> Room.changeset(room_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    case Chat.create_room(room_params) do
      {:ok, _} ->
        # TODO: Redirect to the created room
        {:noreply, redirect(socket, to: ~s"/")}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "Could not save the room.") |> IO.inspect()}
    end
  end
end
