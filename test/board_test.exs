defmodule GameOfLife.BoardTest do
  use ExUnit.Case, async: true

  test "add new cells to alive without duplicates" do
    alive_cells = [{1, 1}, {2, 2}]
    new_cells = [{0, 0}, {1, 1}]

    next_alive_cells =
      GameOfLife.Board.add_cells(alive_cells, new_cells)
      |> Enum.sort()

    expected_alive_cells = [{1, 1}, {2, 2}, {0, 0}] |> Enum.sort()

    assert next_alive_cells == expected_alive_cells
  end

  test "remove dead cells from alive" do
    alive_cells = [{1, 1}, {2, 2}]
    remove_cells = [{2, 2}]

    result_cells = GameOfLife.Board.remove_cells(alive_cells, remove_cells) |> Enum.sort()

    expected = [{1, 1}] |> Enum.sort()

    assert result_cells == expected
  end

  test "alive cell with 2 neighbours stays live on next generation" do
    alive_cells = [{1, 1}, {1, 0}, {1, 2}]
    result_cells = GameOfLife.Board.keep_alive_tick(alive_cells) |> Enum.sort()
    expected = [{1, 1}] |> Enum.sort()

    assert expected == result_cells
  end

  test "dead cell with exactly 3 alive neighbours become alive" do
    alive_cells = [{0, 0}, {1, 0}, {2, 0}, {1, 1}]
    born_cells = GameOfLife.Board.become_alive_tick(alive_cells) |> Enum.sort()
    expected_born_cells = [{1, -1}, {0, 1}, {2, 1}] |> Enum.sort()

    assert born_cells == expected_born_cells
  end
end
