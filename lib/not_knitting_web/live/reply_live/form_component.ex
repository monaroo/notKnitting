defmodule NotKnittingWeb.ReplyLive.FormComponent do
  use NotKnittingWeb, :live_component

  alias NotKnitting.Replies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <:subtitle>Use this form to manage reply records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reply-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save reply</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{reply: reply} = assigns, socket) do
    changeset = Replies.change_reply(reply)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def update(assigns, socket) do
    assigns
    |> Map.keys()
    |> IO.inspect(label: "generic update, assigns:")

    {:ok,
     socket}

  end


  @impl true
  def handle_event("validate", %{"reply" => reply_params}, socket) do
    reply_params = Map.put(reply_params, "pattern_id", socket.assigns.id)

    changeset =
      socket.assigns.reply
      |> Replies.change_reply(reply_params)
      |> Map.put(:action, :validate)
      |> IO.inspect(label: "changeset in validate")
      |> dbg()

    {:noreply, assign_form(socket, changeset)}
  end



  def handle_event("save", %{"reply" => reply_params}, socket) do
    reply_params = Map.put(reply_params, "pattern_id", socket.assigns.id)

    save_reply(socket, socket.assigns.action, reply_params)
  end

  defp save_reply(socket, :edit_reply, reply_params) do
    IO.inspect(reply_params, label: "params in edit")

    case Replies.update_reply(socket.assigns.reply, reply_params) do
      {:ok, reply} ->
        notify_parent({:saved, reply})

        {:noreply,
         socket
         |> put_flash(:info, "reply updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_reply(socket, :new_reply, reply_params) do
    IO.inspect(reply_params, label: "params in create")

    case Replies.create_reply(reply_params) do
      {:ok, reply} ->
        IO.inspect("saved ok")
        notify_parent({:saved, reply})

        {:noreply,
         socket
         |> put_flash(:info, "reply created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->

        {:noreply, assign_form(socket, changeset)}
    end
  end

  # defp save_reply(socket, :edit_reply, reply_params) do

  #   case replys.update_reply(reply_params) do
  #     {:ok, reply} ->
  #       IO.inspect("saved ok")
  #       notify_parent({:saved, reply})
  #       assign(socket, @selected_reply, reply)

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "reply updated successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->

  #       {:noreply, assign_form(socket, changeset)}
  #   end
  # end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
