defmodule NotKnittingWeb.MessageLive.FormComponent do
  use NotKnittingWeb, :live_component

  alias NotKnitting.Messages

  @impl true
  def render(assigns) do
    ~H"""
    <div>


      <.simple_form
        for={@form}
        id="message-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Message" />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />

        <:actions>
          <.button phx-disable-with="Saving...">Send Message</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{message: message} = assigns, socket) do
    changeset = Messages.change_message(message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      socket.assigns.message
      |> Messages.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do

    save_message(socket, socket.assigns.action, message_params)
  end

  # defp get_entry_extension(entry) do
  #   [ext | _] = MIME.extensions(entry.client_type)
  #   ext
  # end

  defp save_message(socket, :edit, message_params) do
    case Messages.update_message(socket.assigns.message, message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})
        NotKnittingWeb.Endpoint.broadcast_from(self(), "messages", "edit", message)
        # Phoenix.PubSub.broadcast(NotKnitting.PubSub, "messages", {:message_update, message})

        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_message(socket, :new, message_params) do
    case Messages.create_message(message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})
        NotKnittingWeb.Endpoint.broadcast_from(self(), "messages", "new", message)


        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
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
