defmodule GameOfLife.Board do
  @type cell :: GameOfLife.Cell.cell()

  @spec add_cells(list(cell), list(cell)) :: list(cell)
  def add_cells(alive_cells, new_cells) do
    (alive_cells ++ new_cells)
    |> Enum.uniq()
  end

  @spec add_cells(list(cell), list(cell)) :: list(cell)
  def remove_cells(alive_cells, remove_cells) do
    alive_cells -- remove_cells
  end

  @doc """
  Iterate over all cells using tasks. Try to show all alive cells after iteration
  """
  @spec keep_alive_tick(list(cell)) :: list(cell)
  def keep_alive_tick(alive_cells) do
    alive_cells
    |> Enum.map(
      &Task.Supervisor.async(
        {GameOfLife.TaskSupervisor, GameOfLife.NodeManager.random_node()},
        GameOfLife.Board,
        :keep_alive_or_nilify,
        [alive_cells, &1]
      )
    )
    |> Enum.map(&Task.await/1)
    |> remove_nil_cells
  end

  @spec keep_alive_or_nilify(list(cell), cell) :: cell | nil
  def keep_alive_or_nilify(alive_cells, cell) do
    if GameOfLife.Cell.keep_alive?(alive_cells, cell), do: cell, else: nil
  end

  defp remove_nil_cells(cells) do
    cells
    |> Enum.filter(fn cell -> cell != nil end)
  end

  @doc """
  Iterate over all cells using tasks. Returns list of new born cells
  """
  @spec become_alive_tick(list(cell)) :: list(cell)
  def become_alive_tick(alive_cells) do
    GameOfLife.Cell.dead_neighbours(alive_cells)
    |> Enum.map(
      &Task.Supervisor.async(
        {GameOfLife.TaskSupervisor, GameOfLife.NodeManager.random_node()},
        GameOfLife.Board,
        :become_alive_or_nilify,
        [alive_cells, &1]
      )
    )
    |> Enum.map(&Task.await/1)
    |> remove_nil_cells
  end

  @spec become_alive_or_nilify(list(cell), cell) :: cell | nil
  def become_alive_or_nilify(alive_cells, dead_cell) do
    if GameOfLife.Cell.become_alive?(alive_cells, dead_cell), do: dead_cell, else: nil
  end
end
