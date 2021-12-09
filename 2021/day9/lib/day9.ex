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
    input
    |> Grid.new()
    |> get_low_points()
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  @doc """
      iex>Day9.part2(\"""
      ...>2199943210
      ...>3987894921
      ...>9856789892
      ...>8767896789
      ...>9899965678
      ...>\""")
      1134
  """
  def part2(input) do
    grid = Grid.new(input)

    [lb0, lb1, lb2 | _] =
      grid
      |> get_low_points()
      |> Enum.map(fn low_point -> find_basin(grid, low_point, []) end)
      |> Enum.map(&length/1)
      |> Enum.sort(:desc)

    lb0 * lb1 * lb2
  end

  defp find_basin(grid, points, acc) when is_list(points) do
    Enum.reduce(points, acc, fn point, acc -> find_basin(grid, point, acc) end)
  end

  defp find_basin(grid, {{row, col}, value} = point, acc) do
    new_points =
      grid
      |> Grid.get_adjacents(row, col)
      |> Enum.filter(fn {_, adj_value} -> value < adj_value and adj_value < 9 end)

    find_basin(grid, new_points, [point | new_points] ++ acc)
  end

  defp find_basin(_grid, [], acc) do
    Enum.uniq(acc)
  end

  defp get_low_points(grid) do
    Enum.filter(grid, fn {{row, col}, value} ->
      grid
      |> Grid.get_adjacents(row, col)
      |> Enum.all?(fn {_, adj_value} -> value < adj_value end)
    end)
  end
end
