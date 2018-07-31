defmodule UiWeb.PageController do
  use UiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def turn_on(conn, _params) do
    IO.puts "on"
    GenServer.call(:gpio_worker, :turn_on)
    render conn, "index.html"
  end

  def turn_off(conn, _params) do
    IO.puts "off"
    GenServer.call(:gpio_worker, :turn_off)
    render conn, "index.html"
  end
end
