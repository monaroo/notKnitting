defmodule NotKnittingWeb.Router do
  use NotKnittingWeb, :router

  import NotKnittingWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NotKnittingWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NotKnittingWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :protected_patterns,
      on_mount: [
        {NotKnittingWeb.UserAuth, :ensure_authenticated},
        {NotKnittingWeb.UserAuth, :require_user_owns_pattern} ] do

        live "/patterns/new", PatternLive.Index, :new
        live "/patterns/:id/edit", PatternLive.Index, :edit
        live "/patterns/:id/show/edit", PatternLive.Show, :edit
        live "/patterns/:id/comments/new", PatternLive.Show, :new_comment
        live "/patterns/:id/comments/:comment_id/edit", PatternLive.Show, :edit_comment

        end

        live_session :protected_messages,
        on_mount: [
          {NotKnittingWeb.UserAuth, :ensure_authenticated},
          {NotKnittingWeb.UserAuth, :require_user_owns_message} ] do

          live "/messages/new", MessageLive.Index, :new
          live "/messages/:id/edit", MessageLive.Index, :edit
          live "/messages/:id/replies", MessageLive.Index, :new_reply
          live "/messages/:id/replies/:reply_id/edit", MessageLive.Index, :edit_reply

        # live "/comments/new", CommentLive.Index, :new
     end
  end

  scope "/", NotKnittingWeb do
    pipe_through :browser

    get "/", PageController, :home

    # live "/patterns/new", PatternLive.Index, :new
    # live "/patterns/:id/edit", PatternLive.Index, :edit
    live_session :patterns, on_mount: [{NotKnittingWeb.UserAuth, :mount_current_user}] do
    live "/patterns", PatternLive.Index, :index
    live "/patterns/search", PatternLive.Search, :search_index
    live "/patterns/:id", PatternLive.Show, :show
    end
    # live "/patterns/:id/show/edit", PatternLive.Show, :edit
    live_session :messages, on_mount: [{NotKnittingWeb.UserAuth, :mount_current_user}] do
    live "/messages", MessageLive.Index, :index


  end
end

  # Other scopes may use custom stacks.
  # scope "/api", NotKnittingWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:not_knitting, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NotKnittingWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", NotKnittingWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{NotKnittingWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", NotKnittingWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{NotKnittingWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", NotKnittingWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{NotKnittingWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
