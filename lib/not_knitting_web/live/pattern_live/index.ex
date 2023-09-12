defmodule NotKnittingWeb.PatternLive.Index do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Patterns
  alias NotKnitting.Patterns.Pattern

  @limit 7

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :patterns, Patterns.list_patterns())}

    {:ok,
    socket
    |> assign(:page, 1)
    |> assign(:limit, @limit)
    |> stream(:patterns, Patterns.list_patterns(limit: @limit))
  }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pattern")
    |> assign(:pattern, Patterns.get_pattern!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pattern")
    |> assign(:pattern, %Pattern{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Patterns")
    |> assign(:pattern, nil)
  end

  @impl true
  def handle_info({NotKnittingWeb.PatternLive.FormComponent, {:saved, pattern}}, socket) do
    {:noreply, stream_insert(socket, :patterns, pattern)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    id = List.last(String.split(id, "-"))
    current_user = socket.assigns.current_user
    %{user_id: user_id} = pattern = Patterns.get_pattern!(id)
    case current_user do
      %{id: ^user_id} ->  {:ok, _} = Patterns.delete_pattern(pattern)
       {:noreply, stream_delete(socket, :patterns, pattern)}

      _ -> {:noreply, socket}
    end

  end

  @impl true
  def handle_event("load-more", _params, socket) do
    offset =  socket.assigns.page * @limit
    patterns = Patterns.list_patterns(offset: offset, limit: @limit)

    {:noreply,
      socket
      |> assign(:page, socket.assigns.page + 1)
      |> stream_insert_many(:patterns, patterns)}
  end

  defp stream_insert_many(socket, ref, patterns) do
    Enum.reduce(patterns, socket, fn pattern, socket ->
      stream_insert(socket, ref, pattern)
    end)
  end

  defp truncate_text(text) do
    if String.length(text) > 100 do
      String.slice(text, 0..100) <> "..."
    else
      text
    end
  end

end
