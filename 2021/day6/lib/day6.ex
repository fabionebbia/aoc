defmodule Day6 do
  @doc """

      iex>Day6.solve("3,4,3,1,2", 80)
      26

  """
  def solve(input, days) do
    fish = parse_input(input)

    Enum.reduce(0..(days - 1), fish, fn _, acc ->
      Enum.reduce(acc, %{}, fn {timer, count}, new_fish ->
        if timer == 0 do
          new_fish
          |> Map.update(8, count, &(&1 + count))
          |> Map.update(6, count, &(&1 + count))
        else
          Map.update(new_fish, timer - 1, count, &(&1 + count))
        end
      end)
    end)
    |> Enum.reduce(0, fn {_, count}, acc -> acc + count end)
  end

  defp parse_input(input) when is_binary(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end
end
