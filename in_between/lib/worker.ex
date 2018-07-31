defmodule InBetween.Worker do
  use GenServer

  @doc"""
  This is automatically started by the application.
  """
  def start_link(_name) do
    GenServer.start_link(__MODULE__, nil, [name: :gpio_worker])
  end

  @doc"""
  This is how you'd use the function below:
  GenServer.call(:gpio_worker, :turn_on)
  """
  def handle_call(:turn_on, _from, state) do
    InBetween.GPIO.turn_on(gpio_pid())
    {:reply, "Turned on", state}
  end

  @doc"""
  This is how you'd use the function below:
  GenServer.call(:gpio_worker, :turn_off)
  """
  def handle_call(:turn_off, _from, state) do
    InBetween.GPIO.turn_off(gpio_pid())
    {:reply, "Turned off", state}
  end

  defp gpio_pid() do
    Agent.get(:gpio_agent, &Map.get(&1, :gpio_pid))
  end
end
