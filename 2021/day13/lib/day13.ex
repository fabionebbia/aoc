defmodule Day13 do
  @doc """
      iex>Day13.part1(\"""
      ...>6,10
      ...>0,14
      ...>9,10
      ...>0,3
      ...>10,4
      ...>4,11
      ...>6,0
      ...>6,12
      ...>4,1
      ...>0,13
      ...>10,12
      ...>3,4
      ...>3,0
      ...>8,4
      ...>1,10
      ...>2,14
      ...>8,10
      ...>9,0
      ...>
      ...>fold along y=7
      ...>fold along x=5
      ...>\""")
      17
  """
  def part1(input) do
    {dots, [fold | _]} = parse_input(input)

    dots
    |> fold([fold])
    |> Enum.count()
  end

  def part2(input) do
    {dots, folds} = parse_input(input)

    dots
    |> fold(folds)
    |> print()
  end

  defp fold(dots, [{axis, coord} | folds]) do
    dots
    |> Enum.map(fn
      {x, y} when axis == :y and y > coord ->
        {x, 2 * coord - y}

      {x, y} when axis == :x and x > coord ->
        {2 * coord - x, y}

      dot ->
        dot
    end)
    |> Enum.uniq()
    |> fold(folds)
  end

  defp fold(dots, []), do: dots

  defp print(dots) do
    {max_x, _} = Enum.max_by(dots, fn {x, _} -> x end)
    {_, max_y} = Enum.max_by(dots, fn {_, y} -> y end)

    for y <- 0..max_y, x <- 0..max_x, into: "" do
      more = if x == max_x, do: "\n", else: ""
      if Enum.member?(dots, {x, y}), do: "#" <> more, else: "." <> more
    end
  end

  defp parse_input(input) do
    [dots, folds] = String.split(input, "\n\n", parts: 2)

    dots =
      dots
      |> String.split("\n")
      |> Enum.map(fn coords ->
        coords
        |> String.split(",", parts: 2)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    folds =
      folds
      |> String.split("\n", trim: true)
      |> Enum.map(fn fold ->
        [axis, coord] =
          fold
          |> String.split([" ", "="], parts: 4)
          |> Enum.drop(2)

        {String.to_atom(axis), String.to_integer(coord)}
      end)

    {dots, folds}
  end
end
