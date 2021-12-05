defmodule Day3 do
  @doc """
    Parses the input.

      iex> Day3.bit_frequencies(\"""
      ...>00100
      ...>11110
      ...>10110
      ...>10111
      ...>10101
      ...>\""")
      [
        %{"0" => 1, "1" => 4},
        %{"0" => 4, "1" => 1},
        %{"1" => 5},
        %{"0" => 2, "1" => 3},
        %{"0" => 3, "1" => 2}
      ]

  """
  def bit_frequencies(input) when is_binary(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.frequencies/1)
  end

  @doc """

      iex> Day3.bit_frequencies(\"""
      ...>00100
      ...>11110
      ...>10110
      ...>10111
      ...>10101
      ...>01111
      ...>00111
      ...>11100
      ...>10000
      ...>11001
      ...>00010
      ...>01010
      ...>\""") |> Day3.calculate_rate(:gamma)
      22

  """
  def calculate_rate(frequencies, type) when is_list(frequencies) do
    comparator =
      case type do
        :gamma -> &Enum.max_by/2
        :epsilon -> &Enum.min_by/2
      end

    rate =
      Enum.reduce(frequencies, "", fn freq, acc ->
        next =
          case map_size(freq) do
            1 ->
              frequencies
              |> Map.keys()
              |> Map.get(0)

            2 ->
              {next, _} = comparator.(freq, fn {_key, value} -> value end)
              next
          end

        acc <> next
      end)

    {parsed, _} = Integer.parse(rate, 2)
    parsed
  end

  @doc """

    iex>Day3.part2(\"""
    ...>00100
    ...>11110
    ...>10110
    ...>10111
    ...>10101
    ...>01111
    ...>00111
    ...>11100
    ...>10000
    ...>11001
    ...>00010
    ...>01010
    ...>\""", :oxygen)
    23

  """
  def part2(input, rating) do
    numbers = String.split(input, "\n", trim: true)

    {parsed, _} =
      advance(numbers, rating)
      |> Integer.parse(2)

    parsed
  end

  defp frequencies(numbers) do
    numbers
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.frequencies/1)
  end

  def advance(numbers, rating) do
    do_advance(numbers, rating, 0)
  end

  defp do_advance([number], _rating, _iteration), do: number

  defp do_advance(numbers, rating, iteration) do
    {rating_bit, comparator} =
      case rating do
        :oxygen -> {"1", &Enum.max_by/2}
        :co2 -> {"0", &Enum.min_by/2}
      end

    frequency =
      numbers
      |> frequencies()
      |> Enum.at(iteration)

    new_numbers =
      case frequency do
        # same frequency f0
        %{"0" => f0, "1" => f1} when f0 === f1 ->
          Enum.filter(numbers, fn n -> String.at(n, iteration) === rating_bit end)

        # different frequency
        %{"0" => _, "1" => _} ->
          {to_keep, _} = comparator.(frequency, fn {_key, value} -> value end)
          Enum.filter(numbers, fn n -> String.at(n, iteration) === to_keep end)
      end

    do_advance(new_numbers, rating, iteration + 1)
  end
end
