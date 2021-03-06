defmodule Test1Web.Router do
  use Test1Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Test1Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true

    scope "/events" do
      get "/upcomming", EventController, :upcomming
      get "/past", EventController, :past
    end
    resources "/events", EventController
  end
end
