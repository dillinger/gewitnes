defmodule GewitnesWeb.PageController do
  use GewitnesWeb, :controller

  def home(conn, _params) do
    fake_user_id = 1

    conn
    |> assign(:auth_token, generate_auth_token(conn, fake_user_id))
    |> assign(:user_id, fake_user_id)
    |> render(:home, layout: false)

    # The home page is often custom made,
    # so skip the default app layout.
  end

  defp generate_auth_token(conn, user_id) do
    Phoenix.Token.sign(conn, "salt identifier", user_id)
  end
end
