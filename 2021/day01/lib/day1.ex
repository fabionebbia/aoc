defmodule Day1 do
  @doc """
    Parses input.

      iex> Day1.parse_input(\"""
      ...> 199
      ...> 200
      ...> 208
      ...> 210
      ...> 200
      ...> 207
      ...> 240
      ...> 269
      ...> 260
      ...> 263
      ...> \""")
      [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

  """
  def parse_input(input) when is_binary(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
    Classifies measurements.

      iex> Day1.classify([199, 200, 208, 210, 200])
      [{199, :none}, {200, :increase}, {208, :increase}, {210, :increase}, {200, :decrease}]

  """
  def classify([first | measurements]) when is_list(measurements) do
    do_classify(measurements, first, [{first, :none}])
  end

  defp do_classify([], _, acc) do
    Enum.reverse(acc)
  end

  defp do_classify([current | measurements], previous, acc) do
    change =
      cond do
        previous < current -> :increase
        previous > current -> :decrease
        true -> :none
      end

    do_classify(measurements, current, [{current, change} | acc])
  end

  @doc """
    Classifies measurements.

      iex> Day1.count_increased([{199, :none}, {200, :increase}, {208, :increase}, {210, :increase}, {200, :decrease}])
      3

  """
  def count_increased(measurements) do
    measurements
    |> Enum.filter(fn {_, change} -> change === :increase end)
    |> Enum.count()
  end

  @doc """
    Calculate three-window sums.

      iex> Day1.three_window([199, 200, 208, 210, 200, 190])
      [607, 618, 618, 600]

  """
  def three_window(list) do
    do_three_window(list, [])
  end

  def do_three_window(list, acc) when length(list) < 3 do
    Enum.reverse(acc)
  end

  def do_three_window([head | tail], acc) do
    sum = head + Enum.sum(Enum.take(tail, 2))
    do_three_window(tail, [sum | acc])
  end
end
