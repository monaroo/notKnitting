defmodule NotKnittingWeb.MessageLive.Index do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Messages
  alias NotKnitting.Messages.Message

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      NotKnittingWeb.Endpoint.subscribe("messages")
      # Phoenix.PubSub.subscribe(NotKnitting.PubSub, "messages")
    end

    {:ok, stream(socket, :messages, Messages.list_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Messages.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "messages", event: "new", payload: message}, socket) do
    IO.inspect(message, label: "1 ---------->")
    {:noreply, stream_insert(socket, :messages, message, at: 0)}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "messages", event: "edit", payload: message}, socket) do
   IO.inspect(message, label: "2 ---------->")
    {:noreply, stream_insert(socket, :messages, message, at: 0)}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "messages", event: "delete", payload: message}, socket) do
    IO.inspect(message, label: "3 ---------->")
    {:noreply, stream_delete(socket, :messages, message)}
  end

  @impl true
  def handle_info({NotKnittingWeb.MessageLive.FormComponent, {:saved, message}}, socket) do
    IO.inspect(message, label: "4 ---------->")
    {:noreply, stream_insert(socket, :messages, message, at: 0)}
  end


  @impl true
  def handle_info(message, socket) do
    IO.inspect(message, label: "unexpected msg")
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    %{user_id: user_id} = message = Messages.get_message!(id)
    case current_user do
      %{id: ^user_id} ->
         {:ok, _} = Messages.delete_message(message)
         NotKnittingWeb.Endpoint.broadcast_from(self(), "messages", "delete", message)
         {:noreply, stream_delete(socket, :messages, message)}

      _ -> {:noreply,
        Phoenix.LiveView.put_flash(
        socket,
        :error,
        "You are not authorized to delete this message.")}
    end

  end

end
