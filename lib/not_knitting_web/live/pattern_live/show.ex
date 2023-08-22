defmodule NotKnittingWeb.PatternLive.Show do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Patterns

  @impl true
  def mount(_params, _session, socket) do
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

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pattern, Patterns.get_pattern!(id))}
  end

  defp page_title(:show), do: "Show Pattern"
  defp page_title(:edit), do: "Edit Pattern"
end
