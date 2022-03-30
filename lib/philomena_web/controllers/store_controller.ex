defmodule PhilomenaWeb.StoreController do
  use PhilomenaWeb, :controller

  alias Philomena.Badges.Badge
  alias Philomena.Badges.Award
  alias Philomena.Repo
  import Ecto.Query

  def index(conn, _params) do
    render(conn, "index.html", title: "Store")
  end

  def create(%{assigns: %{current_user: user}} = conn, _params) when not is_nil(user) do
    case maybe_assign_badge(user) do
      true ->
        conn
        |> put_flash(:info, "Added product to... actually, just have a badge, happy April Fools <3")
        |> redirect(to: "/store")
      _ ->
        conn
        |> put_flash(:error, "You already have the event badge.")
        |> redirect(to: "/store")
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "You must be logged in to add products to cart.")
    |> redirect(to: "/store")
  end

  defp maybe_assign_badge(%{id: user_id}) do
    badge = Repo.get_by(limit(Badge, 1), title: "Even Worse Kobold")

    if not is_nil(badge) do
      award = Repo.get_by(limit(Award, 1), badge_id: badge.id, user_id: user_id)

      if is_nil(award) do
        %Award{
          badge_id: badge.id,
          user_id: user_id,
          awarded_by_id: user_id,
          awarded_on: DateTime.truncate(DateTime.utc_now(), :second)
        }
        |> Award.changeset(%{})
        |> Repo.insert()

        true
      end
    end
  end
end
