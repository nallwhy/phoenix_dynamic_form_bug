defmodule DynamicFormWeb.Router do
  use DynamicFormWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DynamicFormWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DynamicFormWeb do
    pipe_through :browser

    live "/", Live
  end

  # Other scopes may use custom stacks.
  # scope "/api", DynamicFormWeb do
  #   pipe_through :api
  # end
end
