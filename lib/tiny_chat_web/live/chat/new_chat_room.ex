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

          <%= if length(@errors) !== 0 do %>
            <div class="rounded-2xl bg-zinc-50 text-zinc-900 p-4">
              <%= for error <- @errors do %>
                <p>- <%= error %></p>
              <% end %>
            </div>
          <% end %>

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

    {:ok, socket |> assign(form: form) |> assign(errors: [])}
  end

  def handle_event("validate", %{"room" => params}, socket) do
    {:noreply, assign(socket, form: put_changeset(params))}
  end

  def handle_event("save", %{"room" => params}, socket) do
    case Chat.create_room(params) do
      {:ok, _} ->
        {:noreply, redirect(socket, to: ~s"/" <> params["slug"])}

      {:error, reason} ->
        {:noreply,
         socket
         |> assign(:form, put_changeset(params))
         |> assign(:errors, put_errors(reason))}
    end
  end

  defp put_changeset(params) do
    %Room{}
    |> Room.changeset(params)
    |> Map.put(:action, :validate)
    |> to_form()
  end

  defp put_errors(reason) do
    case reason do
      %Ecto.Changeset{} = changeset ->
        changeset
        |> Map.get(:errors)
        |> Enum.map(fn {k, v} -> to_string(k) <> " " <> elem(v, 0) end)

      _ ->
        ["Could not save the room."]
    end
  end
end
