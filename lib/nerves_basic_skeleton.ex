defmodule NervesBasicSkeleton do
  @moduledoc """
  Documentation for NervesBasicSkeleton.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NervesBasicSkeleton.hello
      :world

  """
  def hello do
    :yay
  end

  ## Copy paste to check things out

  require Logger

  alias ElixirALE.GPIO

  @output_pin Application.get_env(:hello_gpio, :output_pin, 26)
  @input_pin Application.get_env(:hello_gpio, :input_pin, 20)
  @sleep_time(1000)

  def start(_type, _args) do
    Logger.info("Starting pin #{@output_pin} as output")
    {:ok, output_pid} = GPIO.start_link(@output_pin, :output)
    spawn(fn -> toggle_pin_forever(output_pid) end)
  end

  defp toggle_pin_forever(output_pid) do
    Logger.debug("Turning pin #{@output_pin} ON")
    GPIO.write(output_pid, 1)
    Process.sleep(@sleep_time)

    Logger.debug("Turning pin #{@output_pin} OFF")
    GPIO.write(output_pid, 0)
    Process.sleep(@sleep_time)

    toggle_pin_forever(output_pid)
  end
end
