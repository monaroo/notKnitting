defmodule NotKnittingWeb.MessageLive.Index do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Messages
  alias NotKnitting.Messages.Message
  alias NotKnitting.Replies.Reply

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      NotKnittingWeb.Endpoint.subscribe("messages")
      NotKnittingWeb.Endpoint.subscribe("replies")
      # Phoenix.PubSub.subscribe(NotKnitting.PubSub, "messages")
    end

    socket =
      socket
      |> stream(:messages, Messages.list_messages())
      |> assign(:message, nil)

    {:ok, socket}
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

  defp apply_action(socket, :new_reply, %{"id" => id} = params) do
    socket
    |> assign(:page_title, "New reply")
    |> assign(:message, Messages.get_message!(id))
    |> assign(:reply, %Reply{})
  end

  defp apply_action(socket, :edit_reply, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit reply")
    |> assign(:reply, Replies.get_reply!(id))
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "messages", event: "new", payload: message}, socket) do
    {:noreply, stream_insert(socket, :messages, message, at: 0)}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "messages", event: "edit", payload: message}, socket) do
    {:noreply, stream_insert(socket, :messages, message, at: 0)}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "messages", event: "delete", payload: message}, socket) do
    {:noreply, stream_delete(socket, :messages, message)}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "replies", event: "new", payload: reply}, socket) do
    IO.inspect(reply.message_id)
    IO.puts(">>>>>>> #{inspect(self())} got notification of new reply...")
    {:noreply, stream_insert(socket, :messages, Messages.get_message!(reply.message_id), at: 0)}
  end

  # def handle_info(%Phoenix.Socket.Broadcast{topic: "replies", event: "edit", payload: reply}, socket) do
  #   {:noreply, stream_insert(socket, :replies, reply, at: 0)}
  # end

  # def handle_info(%Phoenix.Socket.Broadcast{topic: "replies", event: "delete", payload: reply}, socket) do
  #   {:noreply, stream_delete(socket, :replies, reply)}
  # end

  @impl true
  def handle_info({NotKnittingWeb.MessageLive.FormComponent, {:saved, message}}, socket) do
    IO.inspect(socket.assigns.message, label: "----------------------------")
    {:noreply, stream_insert(socket, :messages, message, at: 0)}

  end

  @impl true
  def handle_info({NotKnittingWeb.ReplyLive.FormComponent, {:saved, reply}}, socket) do
    IO.inspect(reply, label: ">>>>>>>>>>>>>>>>>>>")
    {:noreply, stream_insert(socket, :messages, Messages.get_message!(reply.message_id), at: 0)}

  end


  @impl true
  def handle_info(message, socket) do
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
