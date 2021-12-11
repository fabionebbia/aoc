defmodule Day11 do
  @doc """
      iex>Day11.part1(\"""
      ...>5483143223
      ...>2745854711
      ...>5264556173
      ...>6141336146
      ...>6357385478
      ...>4167524645
      ...>2176841721
      ...>6882881134
      ...>4846848554
      ...>5283751526
      ...>\""", 100)
      1656
  """
  def part1(input, steps) do
    octopi = parse_input(input)

    {flash_count, _} =
      Enum.reduce(1..steps, {0, octopi}, fn _, {flash_count, octopi} ->
        {flash_increment, octopi} = step(octopi)
        {flash_count + flash_increment, octopi}
      end)

    flash_count
  end

  @doc """
      iex>Day11.part2(\"""
      ...>5483143223
      ...>2745854711
      ...>5264556173
      ...>6141336146
      ...>6357385478
      ...>4167524645
      ...>2176841721
      ...>6882881134
      ...>4846848554
      ...>5283751526
      ...>\""")
      195
  """
  def part2(input) do
    input
    |> parse_input()
    |> part2(0)
  end

  defp part2(octopi, step_count) do
    {flash_count, octopi} = step(octopi)
    step_count = step_count + 1

    if flash_count == map_size(octopi) do
      step_count
    else
      part2(octopi, step_count)
    end
  end

  defp step(octopi) do
    # Increments the energy level of each octopus by 1
    octopi = for {coord, energy} <- octopi, into: %{}, do: {coord, energy + 1}

    # Flash octopi
    {octopi, flashed} = flash(octopi)

    # Reset the energy level of each octopus that flashed during this step to 0
    octopi =
      for coord <- flashed, into: octopi do
        {coord, 0}
      end

    {length(flashed), octopi}
  end

  defp flash(octopi) do
    flash(octopi, Map.keys(octopi), [])
  end

  defp flash(octopi, [], flashed), do: {octopi, flashed}

  defp flash(octopi, coords, flashed) when is_list(coords) do
    coords
    |> Enum.filter(fn coord -> octopi[coord] == 10 end)
    |> Enum.reduce({octopi, flashed}, fn coord, {octopi, flashed} ->
      flash(octopi, coord, flashed)
    end)
  end

  defp flash(octopi, coord, flashed) do
    {octopi, adjacents} = increment_adjacents(octopi, coord)
    flash(octopi, adjacents, [coord | flashed])
  end

  defp increment_adjacents(octopi, {row, col}) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.reduce({octopi, []}, fn coord, {octopi, existing} = acc ->
      if octopi[coord] do
        octopi = Map.update!(octopi, coord, &(&1 + 1))
        {octopi, [coord | existing]}
      else
        acc
      end
    end)
  end

  defp parse_input(input) when is_binary(input) do
    lines = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {number, col} <- Enum.with_index(to_charlist(line)),
        into: %{} do
      {{row, col}, number - ?0}
    end
  end
end
