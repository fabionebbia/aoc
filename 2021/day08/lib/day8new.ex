# {segments(1) in segments(x), (segments(4) -- segments(1)) in segments(x), length(segments(x))}

# {true, true, _} -> 9
# {true, false, 5} -> 3
# {true, false, 6} -> 6
# {false, false, _} -> 2
# {false, true, 5} -> 5
# {false, true, 6} -> 6

defmodule Day8New do
  @all_segments ["a", "b", "c", "d", "e", "f", "g"]

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(&process_line/1)
    |> Enum.sum()
  end

  defp process_line({patterns, digits}) do
    any = MapSet.new(@all_segments)
    deductions = Enum.into(@all_segments, %{}, fn segment -> {segment, any} end)

    %{
      2 => [bind1],
      3 => [bind7],
      4 => [bind4],
      5 => bind235,
      6 => bind069,
      7 => _bind8
    } = Enum.group_by(patterns, &String.length/1)

    [{1, pattern1}, {3, pattern3}] = calculate_overlaps([bind1, bind4, bind7])

    deductions =
      deductions
      |> bind_pattern(pattern1, "abd")
      |> bind_pattern(pattern3, "cf")

    [{1, pattern1}, {2, pattern2}, {3, pattern3}] = calculate_overlaps(bind235)

    deductions =
      deductions
      |> bind_pattern(pattern1, "be")
      |> bind_pattern(pattern2, "cf")
      |> bind_pattern(pattern3, "adg")

    [{2, pattern2}, {3, pattern3}] = calculate_overlaps(bind069)

    deductions =
      deductions
      |> bind_pattern(pattern2, "cde")
      |> bind_pattern(pattern3, "abfg")

    deductions = %{deductions | "a" => MapSet.new(String.graphemes(bind7) -- String.graphemes(bind1))}

    meaning = digits
    |> Enum.map(&String.graphemes/1)
    |> Enum.reduce("", fn digit, acc ->
      inc = case length(digit) do
        2 -> "1"
        3 -> "7"
        4 -> "4"
        5 ->
          cond do

            Enum.member?(digit, retrieve_binding(deductions, "b")) -> "5"
            Enum.member?(digit, retrieve_binding(deductions, "e")) -> "2"
            true ->
              "3"
          end
        6 ->
          cond do
            not Enum.member?(digit, retrieve_binding(deductions, "d")) -> "0"
            Enum.member?(digit, retrieve_binding(deductions, "e")) -> "6"
            true -> "9"
          end
        7 -> "8"
      end

      acc <> inc
    end)
    |> String.to_integer()

    IO.inspect({digits, meaning})

    meaning
  end

  defp retrieve_binding(deductions, signal) do
    deductions[signal]
    |> MapSet.to_list()
    |> Enum.at(0)
  end

  defp calculate_overlaps(signals) do
    signals
    |> Enum.join("")
    |> String.graphemes()
    |> Enum.frequencies()
    |> Enum.group_by(fn {_, v} -> v end)
    |> Enum.map(fn {k, v} ->
      v =
        Enum.map(v, fn {l, _} -> l end)
        |> Enum.join("")

      {k, v}
    end)
  end

  defp bind_pattern(deductions, signals, segments) when not is_list(signals) do
    bind_pattern(deductions, String.graphemes(signals), segments)
  end

  defp bind_pattern(deductions, signals, segments) do
    segments
    |> String.graphemes()
    |> then(&(@all_segments -- &1))
    |> Enum.reduce(deductions, fn segment, acc ->
      Map.update!(acc, segment, &MapSet.difference(&1, MapSet.new(signals)))
    end)
  end

  defp parse_input(input) when is_binary(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn entry ->
      {patterns, [_ | digits]} =
        entry
        |> String.split()
        |> Enum.split(10)

      {patterns, digits}
    end)
  end
end
