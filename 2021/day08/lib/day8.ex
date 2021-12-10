# be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
# edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
# fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
# fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
# aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
# fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
# dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
# bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
# egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
# gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce

#          aaaa
#         b    c
#         b    c
#          dddd
#         e    f
#         e    f
#          gggg

defmodule Day8 do
  @all_segments ["a", "b", "c", "d", "e", "f", "g"]

  def part2(input) do
    any = MapSet.new(@all_segments)
    deductions = Enum.into(@all_segments, %{}, fn segment -> {segment, any} end)

    {patterns, digits} =
      input
      |> parse_input()
      |> List.first()

    Enum.reduce(patterns, deductions, fn pattern, deductions ->
      case String.length(pattern) do
        # 1
        2 -> bind_pattern(deductions, pattern, "cf")
        # 7
        3 -> bind_pattern(deductions, pattern, "acf")
        # 4
        4 -> bind_pattern(deductions, pattern, "bcdf")
        _ -> deductions
      end
    end)
  end

  #          aaaa
  #         b    c
  #         b    c
  #          dddd
  #         e    f
  #         e    f
  #          gggg

  # Binds the given signals to the given segments
  # (and unbdinds the same signals from any other segment)

  def bind_pattern(deductions, signals, segments) do
    signals =
      signals
      |> String.graphemes()
      |> MapSet.new()

    segments
    |> String.graphemes()
    |> then(&(@all_segments -- &1))
    |> Enum.reduce(deductions, fn segment, acc ->
      Map.update!(acc, segment, &MapSet.difference(&1, signals))
    end)
  end

  @doc """
      iex>Day8.part1(\"""
      ...>be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      ...>edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      ...>fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      ...>fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      ...>aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      ...>fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      ...>dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      ...>bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      ...>egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      ...>gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
      ...>\""")
      26
  """
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn {_patterns, digits}, count ->
      digits
      |> Enum.count(fn digit -> String.length(digit) in [2, 3, 4, 7] end)
      |> Kernel.+(count)
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
