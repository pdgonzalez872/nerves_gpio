defmodule UiWeb.PageCommander do
  use Drab.Commander

  defhandler turn_on(_socket, _sender) do
    GenServer.call(:gpio_worker, :turn_on)
  end

  defhandler turn_off(_socket, _sender) do
    GenServer.call(:gpio_worker, :turn_off)
  end
end
