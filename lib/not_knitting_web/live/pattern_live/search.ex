defmodule NotKnittingWeb.PatternLive.Search do
  use NotKnittingWeb, :live_view

  alias NotKnitting.Patterns
  alias NotKnitting.Patterns.Pattern

  @limit 7

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :patterns, Patterns.list_patterns())}
    empty_search = %{query: ""}

    {:ok,
    socket
    |> assign(:page, 1)
    |> assign(:limit, @limit)
    |> assign(:form, to_form(empty_search))
    |> stream(:patterns, Patterns.search_patterns("", @limit))
  }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end



  defp apply_action(socket, :search_index, _params) do
    socket
    |> assign(:page_title, "Search Patterns")
    |> assign(:pattern, nil)
  end

  @impl true
  def handle_event("search", %{"query" => input}, socket) do
    {:noreply, stream(socket, :patterns, Patterns.search_patterns(input, @limit), reset: true)}
  end

  @impl true
  # def handle_event("load-more", _params, socket) do
  #   offset =  socket.assigns.page * @limit
  #   patterns = Patterns.list_patterns(offset: offset, limit: @limit)

  #   {:noreply,
  #     socket
  #     |> assign(:page, socket.assigns.page + 1)
  #     |> stream_insert_many(:patterns, patterns)}
  # end
end
