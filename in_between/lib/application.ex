defmodule InBetween do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(InBetween.Worker, [InBetween.Worker]),
    ]

    IO.puts "In start"
    IO.puts "yay"

    opts = [strategy: :one_for_one, name: InBetween.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
