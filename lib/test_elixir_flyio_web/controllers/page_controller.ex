defmodule TestElixirFlyioWeb.PageController do
  use TestElixirFlyioWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
