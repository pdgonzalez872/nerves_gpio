defmodule InBetween.Worker do
  use GenServer

  def start_link(name \\ nil) do
    GenServer.start_link(__MODULE__, nil, [name: name])
  end

  def handle_call("Hi!", _from, state) do
    IO.puts state
    {:reply, "Hola!", state}
  end

  def handle_cast({:dude, target_pid}, state) do
    {:reply, Map.put(state, :cast_baby, target_pid)}
  end

  def handle_call({:turn_on, target_pid}, _from, state) do
    IO.puts "#{target_pid}"
    #InBetween.turn_on(target_pid)
    {:reply, "Turned on", state}
  end

  def handle_call(:turn_on, _from, state) do
    {:reply, "Turned on", state}

  end

  def handle_call(:turn_off, _from, state) do
    {:reply, "Turned off", state}
  end
end
