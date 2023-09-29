defmodule NotKnittingWeb.CommentLive.FormComponent do
  use NotKnittingWeb, :live_component

  alias NotKnitting.Comments

  @impl true
  def render(assigns) do
    ~H"""
    <div>


      <.simple_form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Comments.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  # def update(assigns, socket) do
  #   assigns
  #   |> Map.keys()
  #   |> IO.inspect(label: "generic update, assigns:")

  #   {:ok,
  #    socket}

  # end


  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    comment_params = Map.put(comment_params, "pattern_id", socket.assigns.id)

    changeset =
      socket.assigns.comment
      |> Comments.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end



  def handle_event("save", %{"comment" => comment_params}, socket) do
    comment_params = Map.put(comment_params, "pattern_id", socket.assigns.id)

    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :edit_comment, comment_params) do

    case Comments.update_comment(socket.assigns.comment, comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        {:noreply,
         socket
         |> put_flash(:info, "comment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_comment(socket, :new_comment, comment_params) do

    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        {:noreply,
         socket
         |> put_flash(:info, "comment created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->

        {:noreply, assign_form(socket, changeset)}
    end
  end

  # defp save_comment(socket, :edit_comment, comment_params) do

  #   case Comments.update_comment(comment_params) do
  #     {:ok, comment} ->
  #       IO.inspect("saved ok")
  #       notify_parent({:saved, comment})
  #       assign(socket, @selected_comment, comment)

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "comment updated successfully")
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
