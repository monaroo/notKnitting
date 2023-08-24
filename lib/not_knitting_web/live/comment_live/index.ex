defmodule NotKnittingWeb.CommentLive.Index do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Comments
  alias NotKnitting.Comments.Comment
  alias NotKnittingWeb.CommentLive.FormComponent

  @impl true
  def render(assigns) do
    FormComponent.render(assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :comments, Comments.list_comments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pattern")
    |> assign(:comment, Comments.get_comment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Comment")
    |> assign(:comment, %Comment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing comments")
    |> assign(:pattern, nil)
  end

  @impl true
  def handle_info({NotKnittingWeb.CommentLive.FormComponent, {:saved, pattern}}, socket) do
    {:noreply, stream_insert(socket, :patterns, pattern)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    %{user_id: user_id} = comment = Comments.get_comment!(id)
    case current_user do
      %{id: ^user_id} ->  {:ok, _} = Comments.delete_comment(comment)
       {:noreply, stream_delete(socket, :comments, comment)}

      _ -> {:noreply, socket}
    end

  end
end
