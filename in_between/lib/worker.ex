defmodule InBetween.Worker do
  use GenServer

  def start_link(_name) do
    GenServer.start_link(__MODULE__, nil, [name: :gpio_pid])
  end

  def handle_call("Hi!", _from, state) do
    IO.puts state
    {:reply, "Hola!", state}
  end

  def handle_call(:turn_on, _from, state) do
    {:reply, "Turned on", state}
  end

  def handle_call(:turn_off, _from, state) do
    {:reply, "Turned off", state}
  end
end
