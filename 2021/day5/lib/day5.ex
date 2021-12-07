defmodule Day5 do
@doc """

      iex> Day5.part1(\"""
      ...>0,9 -> 5,9
      ...>8,0 -> 0,8
      ...>9,4 -> 3,4
      ...>2,2 -> 2,1
      ...>7,0 -> 7,4
      ...>6,4 -> 2,0
      ...>0,9 -> 2,9
      ...>3,4 -> 1,4
      ...>0,0 -> 8,8
      ...>5,5 -> 8,2
      ...>\""")
      5

  """
  def part1(input) when is_binary(input) do
    solve(input, fn {{x0, y0}, {x1, y1}} -> x0 === x1 or y0 === y1 end)
  end

  @doc """

      iex> Day5.part2(\"""
      ...>0,9 -> 5,9
      ...>8,0 -> 0,8
      ...>9,4 -> 3,4
      ...>2,2 -> 2,1
      ...>7,0 -> 7,4
      ...>6,4 -> 2,0
      ...>0,9 -> 2,9
      ...>3,4 -> 1,4
      ...>0,0 -> 8,8
      ...>5,5 -> 8,2
      ...>\""")
      12

  """
  def part2(input) when is_binary(input) do
    solve(input, &Function.identity/1)
  end

  defp solve(input, filter) do
    input
    |> parse_input()
    |> Enum.filter(filter)
    |> Enum.reduce([], &gen_points/2)
    |> Enum.frequencies()
    |> Enum.count(&(elem(&1, 1) >= 2))
  end

  # TIL: Enum.zip(curr_x..target_x, curr_y..target_y) would produce
  #      the same points (in reverse order, but doesn't matter)
  defp gen_points({same, same}, acc), do: [same | acc]

  defp gen_points({{curr_x, curr_y} = current, {target_x, target_y} = target}, acc) do
    next_x = curr_x + step(target_x - curr_x)
    next_y = curr_y + step(target_y - curr_y)

    gen_points({{next_x, next_y}, target}, [current | acc])
  end

  defp step(0), do: 0
  defp step(n), do: div(n, abs(n))

  defp parse_input(input) do
    input
    |> String.split(~r/(\n| -> |,)/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end
end
