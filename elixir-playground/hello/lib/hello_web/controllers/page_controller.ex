defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def greet(conn, _params) do
    render(conn, "greet.html")
  end
end
