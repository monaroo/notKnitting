defmodule NotKnittingWeb.PatternLive.Show do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Patterns
  alias NotKnitting.Comments
  alias NotKnitting.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("delete-comment", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    %{user_id: user_id} = comment = Comments.get_comment!(id)

    case current_user do
      %{id: ^user_id} ->
        {:ok, _} = Comments.delete_comment(comment)

        {:noreply,
         socket
         |> put_flash(:info, "Comment deleted successfully")
         |> push_redirect(to: ~p"/patterns/#{socket.assigns.pattern.id}")}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
   
    current_user = socket.assigns.current_user
    %{user_id: user_id} = pattern = Patterns.get_pattern!(id)

    case current_user do
      %{id: ^user_id} ->
        {:ok, _} = Patterns.delete_pattern(pattern)

        {:noreply,
         socket
         |> put_flash(:info, "Pattern deleted successfully")
         |> push_redirect(to: ~p"/patterns")}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("new comment", %{"id" => id}, socket) do
    id = List.last(String.split(id, "-"))
    current_user = socket.assigns.current_user
    current_pattern = Patterns.get_pattern!(id)

    Comments.create_comment(%{user_id: current_user.id, pattern_id: current_pattern.id})

    {:noreply,
     socket
     |> assign(:selected_comment, Comments.get_comment!(id))
     |> put_flash(:info, "Comment created successfully")}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    id = List.last(String.split(id, "-"))
    comment =
      case Map.get(params, "comment_id") do
        nil -> %Comments.Comment{}
        id -> Comments.get_comment!(id)
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pattern, Patterns.get_pattern!(id))
     |> assign(selected_comment: comment)
    }
  end

  defp page_title(:show), do: "Show Pattern"
  defp page_title(:edit), do: "Edit Pattern"
  defp page_title(:new_comment), do: "New Comment"
  defp page_title(:edit_comment), do: "Edit Comment"
end
