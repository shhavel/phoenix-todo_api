defmodule TodoApi.TodoController do
  use TodoApi.Web, :controller

  alias TodoApi.Todo

  plug :scrub_params, "todo" when action in [:create, :update]

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    query = from t in Todo, where: t.owner_id == ^user_id
    todos = Repo.all(query)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    changeset = Todo.changeset(
      %Todo{owner_id: conn.assigns.current_user.id}, todo_params
    )

    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", todo_path(conn, :show, todo))
        |> render("show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodoApi.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
