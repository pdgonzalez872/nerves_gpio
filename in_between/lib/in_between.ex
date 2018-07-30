defmodule InBetween.GPIO do
  ## This is Frank's code

  require Logger

  alias ElixirALE.GPIO

  @output_pin(26)
  @sleep_time(1000)

  def new_led_pid() do
    Logger.info("Starting pin #{@output_pin} as output")
    {:ok, output_pid} = GPIO.start_link(@output_pin, :output)
    output_pid
  end

  def turn_on(pid) do
    Logger.debug("Turning pin #{@output_pin} ON")
    GPIO.write(pid, 1)
  end

  def turn_off(pid) do
    Logger.debug("Turning pin #{@output_pin} OFF")
    GPIO.write(pid, 0)
  end
end
