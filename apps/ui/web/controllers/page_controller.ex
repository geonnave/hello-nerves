defmodule Ui.PageController do
  use Ui.Web, :controller
  require Logger

  def index(conn, _params) do
    render conn, "index.html"
  end

  def update(conn, _params) do
    Logger.debug "Will toggle LED!"
    HelloGpio.Blinky.toggle
    render conn, "index.html"
  end
end
