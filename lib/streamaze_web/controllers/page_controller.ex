defmodule StreamazeWeb.PageController do
  use StreamazeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
