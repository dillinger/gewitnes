defmodule GewitnesWeb.AuthSocket do
  use Phoenix.Socket
  require Logger

  @one_day 86400

  # channel "book:*", GewitnesWeb.BookChannel
  channel "user:*", GewitnesWeb.AuthChannel
  channel "recurring", GewitnesWeb.RecurringChannel

  @impl true
  def connect(%{"token" => token}, socket) do
    case verify(socket, token) do
      {:ok, user_id} ->
        socket = assign(socket, :user_id, user_id)
        {:ok, socket}

      {:error, err} ->
        Logger.error("#{__MODULE__} connect error #{inspect(err)}")
        :error
    end
  end

  @impl true
  def connect(_, _socket) do
    Logger.error("#{__MODULE__} connect error missing params")
    :error
  end

  @impl true
  def id(%{assigns: %{user_id: user_id}}) do
    "auth_socket:#{user_id}"
  end

  defp verify(socket, token) do
    Phoenix.Token.verify(
      socket,
      "salt identifier",
      token,
      max_age: @one_day
    )
  end
end
