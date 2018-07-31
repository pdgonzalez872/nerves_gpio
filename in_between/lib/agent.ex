defmodule InBetween.GPIOAgent do
  use Agent

  @doc"""
  This is how to retrieve the pid after calling `start_link`
  Agent.get(:gpio_agent, &Map.get(&1, :gpio_pid))
  """
  def start_link(_) do
    Agent.start_link(fn ->
      %{gpio_pid: InBetween.GPIO.new_led_pid()}
    end, name: :gpio_agent)
  end
end
