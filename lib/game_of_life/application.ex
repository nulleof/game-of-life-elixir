defmodule GameOfLife.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    alive_cells_init = []

    children = [
      # Starts a worker by calling: GameOfLife.Worker.start_link(arg)
      # {GameOfLife.Worker, arg}
      {Task.Supervisor, [name: GameOfLife.TaskSupervisor]}
      # GameOfLife.BoardServer, [alive_cells_init]}
      # GameOfLife.GamePrinter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
