defmodule NotKnittingWeb.PatternLive.Show do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Patterns
  alias NotKnitting.Comments
  alias NotKnitting.Accounts


  @impl true
  def mount(_params, _session, socket) do
    socket =
    socket
    |> assign(selected_comment: %Comments.Comment{})
    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    %{user_id: user_id} = pattern = Patterns.get_pattern!(id)
    case current_user do
      %{id: ^user_id} ->  {:ok, _} = Patterns.delete_pattern(pattern)
      {:noreply,
      socket
      |> put_flash(:info, "Pattern deleted successfully")
      |> push_redirect(to: ~p"/patterns")}

      _ -> {:noreply, socket}
    end

  end

  def handle_event("new comment", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    current_pattern = Patterns.get_pattern!(id)

    Comments.create_comment(%{user_id: current_user.id, pattern_id: current_pattern.id})
      {:noreply,
      socket
      |> assign(:selected_comment, Comments.get_comment!(id))
      |> put_flash(:info, "Comment created successfully")
  }
    end

    def handle_event("select-comment", %{"id" => id}, socket) do
         {:noreply,
         assign(socket, selected_comment: Comments.get_comment!(id))
         }
      end

      def handle_event("deselect-comment", _params, socket) do
        {:noreply,
        assign(socket, selected_comment: %Comments.Comment{})
        }
     end



  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pattern, Patterns.get_pattern!(id))}
  end

  defp page_title(:show), do: "Show Pattern"
  defp page_title(:edit), do: "Edit Pattern"
  defp page_title(:new_comment), do: "New Comment"
  defp page_title(:edit_comment), do: "Edit Comment"



end
