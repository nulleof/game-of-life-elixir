defmodule GameOfLife.CellTest do
  use ExUnit.Case, async: true

  test "alive cell with no neighbours dies" do
    alive_cell = {1, 1}
    alive_cells = [alive_cell]
    refute GameOfLife.Cell.keep_alive?(alive_cells, alive_cell)
  end

  test "alive cell with 1 neighbour dies" do
    alive_cell = {1, 1}
    alive_cells = [alive_cell, {0, 0}]
    refute GameOfLife.Cell.keep_alive?(alive_cells, alive_cell)
  end

  test "alive cell with more than 3 neighbours dies" do
    alive_cell = {1, 1}
    alive_cells = [alive_cell, {0, 0}, {1, 0}, {2, 0}, {2, 1}]
    refute GameOfLife.Cell.keep_alive?(alive_cells, alive_cell)
  end

  test "alive cell with 2 neighbours lives" do
    alive_cell = {1, 1}
    alive_cells = [alive_cell, {0, 0}, {1, 0}]
    assert GameOfLife.Cell.keep_alive?(alive_cells, alive_cell)
  end

  test "alive cell with 3 neighbours lives" do
    alive_cell = {1, 1}
    alive_cells = [alive_cell, {0, 0}, {1, 0}, {0, 1}]
    assert GameOfLife.Cell.keep_alive?(alive_cells, alive_cell)
  end

  test "dead cell become alive with 3 neighbours" do
    alive_cells = [{1, 0}, {1, 1}, {0, 1}]
    dead_cell = {0, 0}
    assert GameOfLife.Cell.become_alive?(alive_cells, dead_cell)
  end

  test "dead cell with 2 neighbours stays dead" do
    alive_cells = [{1, 0}, {1, 1}]
    dead_cell = {0, 0}
    refute GameOfLife.Cell.become_alive?(alive_cells, dead_cell)
  end
end
