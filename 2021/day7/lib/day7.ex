defmodule Day7 do
  @doc """
      iex>Day7.part1("16,1,2,0,4,2,7,1,2,14")
      37
  """
  def part1(input) do
    solve(input, &Function.identity/1)
  end

  @doc """
      iex>Day7.part2("16,1,2,0,4,2,7,1,2,14")
      168
  """
  def part2(input) do
    solve(input, &Enum.sum(1..&1))
  end

  defp solve(input, increase_fun) do
    submarines = parse_input(input)
    {min, max} = Enum.min_max(submarines)

    fuel_expenses =
      for pos <- min..max do
        Enum.reduce(submarines, 0, fn submarine, total_fuel ->
          abs(submarine - pos)
          |> then(increase_fun)
          |> Kernel.+(total_fuel)
        end)
      end

    Enum.min(fuel_expenses)
  end

  defp parse_input(input) when is_binary(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
