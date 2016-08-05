defmodule TodoApi.Router do
  use TodoApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug TodoApi.Authentication
  end

  scope "/api", TodoApi do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create]
  end

  scope "/api", TodoApi do
    pipe_through :api_auth

    resources "/todos", TodoController, except: [:new, :edit]
  end
end
