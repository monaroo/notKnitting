defmodule NotKnittingWeb.PatternLive.FormComponent do
  use NotKnittingWeb, :live_component

  alias NotKnitting.Patterns

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage pattern records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="pattern-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Pattern</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{pattern: pattern} = assigns, socket) do
    changeset = Patterns.change_pattern(pattern)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"pattern" => pattern_params}, socket) do
    changeset =
      socket.assigns.pattern
      |> Patterns.change_pattern(pattern_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"pattern" => pattern_params}, socket) do
    save_pattern(socket, socket.assigns.action, pattern_params)
  end

  defp save_pattern(socket, :edit, pattern_params) do
    case Patterns.update_pattern(socket.assigns.pattern, pattern_params) do
      {:ok, pattern} ->
        notify_parent({:saved, pattern})

        {:noreply,
         socket
         |> put_flash(:info, "Pattern updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_pattern(socket, :new, pattern_params) do
    case Patterns.create_pattern(pattern_params) do
      {:ok, pattern} ->
        notify_parent({:saved, pattern})

        {:noreply,
         socket
         |> put_flash(:info, "Pattern created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
