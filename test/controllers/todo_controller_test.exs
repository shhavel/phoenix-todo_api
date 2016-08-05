defmodule TodoApi.TodoControllerTest do
  use TodoApi.ConnCase

  alias TodoApi.Todo
  alias TodoApi.User
  alias TodoApi.Session

  @valid_attrs %{complete: true, description: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = create_user(%{name: "jane"})
    session = create_session(user)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user }
  end

  def create_user(%{name: name}) do
    User.registration_changeset(%User{}, %{email: "#{name}@example.com", password: "secure"}) |> Repo.insert!
  end

  def create_session(user) do
    # in the last blog post I had a copy-paste error
    # so you may need to use Session.registration_changeset
    Session.create_changeset(%Session{user_id: user.id}, %{}) |> Repo.insert!
  end

  def create_todo(%{description: _description, owner_id: owner_id} = options) do
    Todo.changeset(%Todo{owner_id: owner_id}, options) |> Repo.insert!
  end

  test "lists all entries on index", %{conn: conn, current_user: current_user} do
    create_todo(%{description: "our first todo", owner_id: current_user.id})

    another_user = create_user(%{name: "johndoe"})
    create_todo(%{description: "thier first todo", owner_id: another_user.id})

    conn = get conn, todo_path(conn, :index)

    assert Enum.count(json_response(conn, 200)["data"]) == 1
    assert %{"description" => "our first todo"} = hd(json_response(conn, 200)["data"])
  end

  test "creates and renders resource when data is valid", %{conn: conn, current_user: current_user} do
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    todo = Repo.get_by(Todo, @valid_attrs)
    assert todo
    assert todo.owner_id == current_user.id
  end

  test "ignores parameter owner_id and always assigns current_user as entry's owner", %{conn: conn, current_user: current_user} do
    other_user = create_user(%{name: "dougal"})
    malicious_attrs = Map.merge(@valid_attrs, %{owner_id: other_user.id})
    conn = post conn, todo_path(conn, :create), todo: malicious_attrs
    assert json_response(conn, 201)["data"]["id"]
    todo = Repo.get_by(Todo, @valid_attrs)
    assert todo
    assert todo.owner_id == current_user.id
  end

end
