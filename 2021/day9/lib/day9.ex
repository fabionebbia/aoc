defmodule Day9 do
  @doc """
      iex>Day9.part1(\"""
      ...>2199943210
      ...>3987894921
      ...>9856789892
      ...>8767896789
      ...>9899965678
      ...>\""")
      15
  """
  def part1(input) do
    {grid, rows, cols} = parse_input(input)

    grid
    |> get_low_points(rows, cols)
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  def part2(input) do
    {grid, rows, cols} = parse_input(input)
  end

  defp get_low_points(grid, rows, cols) do
    for row <- 0..rows,
        col <- 0..cols do
      coord = {row, col}
      {coord, get_value(grid, coord)}
    end
    |> Enum.map(fn {coord, value} ->
      adjacent_values =
        coord
        |> get_adjacent(rows, cols)
        |> Enum.map(fn adjacent -> {adjacent, get_value(grid, adjacent)} end)

      {coord, value, adjacent_values}
    end)
    |> Enum.filter(fn {_, value, adjacents} ->
      Enum.all?(adjacents, fn {_, adj_value} -> value < adj_value end)
    end)
    |> Enum.map(fn {coord, value, _} -> {coord, value} end)
  end

  defp get_value(grid, {row, col}) do
    grid |> elem(row) |> elem(col)
  end

  defp get_adjacent({row, col}, rows, cols) do
    [
      {row - 1, col},
      {row, col + 1},
      {row + 1, col},
      {row, col - 1}
    ]
    |> Enum.filter(fn {row, col} ->
      row >= 0 and row <= rows and (col >= 0 and col <= cols)
    end)
  end

  defp parse_input(input) when is_binary(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> List.to_tuple()

    rows = tuple_size(grid) - 1
    cols = tuple_size(elem(grid, 0)) - 1

    {grid, rows, cols}
  end
end
