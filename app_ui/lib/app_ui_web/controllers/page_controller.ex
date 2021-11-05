defmodule AppUiWeb.PageController do
  use AppUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
