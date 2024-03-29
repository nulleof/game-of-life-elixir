defmodule GameOfLife.Cell do
  @type cell :: {integer, integer}

  @doc """
  Should this dead cell be alive on next generation?
  """
  @spec become_alive?(list(cell), cell) :: bool
  def become_alive?(alive_cells, {x, y} = _dead_cell) do
    3 == count_neighbours(alive_cells, x, y, 0)
  end

  @doc """
  Should this cell be alive on next generation?

  ## args
    - alive_cells: list of all active cells, can be empty
    - _alive_cell: tuple of given cell coords

  """
  @spec keep_alive?(list(cell), cell) :: bool
  def keep_alive?(alive_cells, {x, y} = _alive_cell) do
    num_neighbours = count_neighbours(alive_cells, x, y, 0)

    case num_neighbours do
      2 -> true
      3 -> true
      _ -> false
    end
  end

  @spec count_neighbours([cell | list(cell)], integer, integer, integer) :: integer
  defp count_neighbours([head_cell | tail_cells], x, y, count) do
    increment =
      case head_cell do
        {hx, hy} when hx == x - 1 and hy == y - 1 -> 1
        {hx, hy} when hx == x and hy == y - 1 -> 1
        {hx, hy} when hx == x + 1 and hy == y - 1 -> 1
        {hx, hy} when hx == x - 1 and hy == y -> 1
        {hx, hy} when hx == x + 1 and hy == y -> 1
        {hx, hy} when hx == x - 1 and hy == y + 1 -> 1
        {hx, hy} when hx == x and hy == y + 1 -> 1
        {hx, hy} when hx == x + 1 and hy == y + 1 -> 1
        _not_neighbour -> 0
      end

    count_neighbours(tail_cells, x, y, count + increment)
  end

  defp count_neighbours([], _x, _y, count), do: count

  @doc """
  Returns list of dead cells that pretend to be alive
  """
  @spec dead_neighbours(list(cell)) :: list(cell)
  def dead_neighbours(alive_cells) do
    neighbours = neighbours(alive_cells, [])

    (neighbours |> Enum.uniq()) -- alive_cells
  end

  defp neighbours([{x, y} | cells], neighbours) do
    new_neighbours = [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]

    neighbours(cells, neighbours ++ new_neighbours)
  end

  defp neighbours([], neighbours), do: neighbours
end
