defmodule TinyChat.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:title, :slug]
  @unique_field :slug

  schema "rooms" do
    field :title, :string
    field :slug, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(room, attrs) do
    room
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> format_slug()
    |> unique_constraint(@unique_field)
  end

  defp format_slug(%Ecto.Changeset{changes: %{slug: _}} = changeset) do
    changeset
    |> update_change(:slug, fn slug ->
      slug
      |> String.downcase()
      |> String.replace(" ", "-")
    end)
  end

  defp format_slug(changeset), do: changeset
end
