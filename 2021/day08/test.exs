import Day8

"acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"

deductions = %{
    "a" => MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
    "b" => MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
    "c" => MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
    "d" => MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
    "e" => MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
    "f" => MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
    "g" => MapSet.new(["a", "b", "c", "d", "e", "f", "g"])
  }
  |> bind_pattern("dab", "acf")
  |> IO.inspect()
  |> bind_pattern("ab", "cf")
  |> IO.inspect()
  |> bind_pattern("eafb", "bcdf")
  |> IO.inspect()

[{2, pattern2}, {3, pattern3}] =
  ["cefabd", "cdfgeb", "cagedb"]
  |> Enum.reduce("", &(&2 <> &1))
  |> String.graphemes()
  |> Enum.frequencies()
  |> Enum.group_by(fn {_, v} -> v end)
  |> Enum.map(fn {k, v} -> {k, Enum.reduce(v, "", fn {letter, _}, acc-> acc <> letter end)} end)

deductions =
  deductions
  |> bind_pattern(pattern2, "cde")
  |> IO.inspect()
  |> bind_pattern(pattern3, "abfg")
  |> IO.inspect()

# deductions
# |> bind_pattern("g", "e")
# |> IO.inspect()
# |> bind_pattern("c", "g")
# |> IO.inspect()
# |> bind_pattern("d", "a")
# |> IO.inspect()

[{1, pattern1}, {2, pattern2}, {3, pattern3}] =
  ["cdfbe", "gcdfa", "fbcad"]
  |> Enum.reduce("", &(&2 <> &1))
  |> String.graphemes()
  |> Enum.frequencies()
  |> Enum.group_by(fn {_, v} -> v end)
  |> Enum.map(fn {k, v} -> {k, Enum.reduce(v, "", fn {letter, _}, acc-> acc <> letter end)} end)
  |> IO.inspect()

deductions =
  deductions
  |> bind_pattern(pattern1, "be")
  |> IO.inspect()
  |> bind_pattern(pattern2, "cf")
  |> IO.inspect()
  |> bind_pattern(pattern3, "adg")
  |> IO.inspect()

deductions
# |> bind_pattern("g", "e")
# |> IO.inspect()
|> bind_pattern("c", "g")
|> IO.inspect()
# |> bind_pattern("d", "a")
# |> IO.inspect()



# |> bind_pattern("acedgfb", "abcdefg")
# |> IO.inspect()
# |> bind_pattern("cdfbe", "acdeg")
# |> bind_pattern("cdfbe", "acdfg")
# |> bind_pattern("cdfbe", "abdfg")
# |> IO.inspect()
# |> bind_pattern("gcdfa", "acdeg")
# |> bind_pattern("gcdfa", "acdfg")
# |> bind_pattern("gcdfa", "abdfg")
# |> IO.inspect()
# |> bind_pattern("fbcad", "acdeg")
# |> bind_pattern("fbcad", "acdfg")
# |> bind_pattern("fbcad", "abdfg")
# |> bind_pattern("cefabd", "abcefg")
# |> bind_pattern("cefabd", "abdefg")
# |> bind_pattern("cefabd", "abcdfg")
# |> IO.inspect()
# |> bind_pattern("cdfgeb", "abcefg")
# |> bind_pattern("cdfgeb", "abdefg")
# |> bind_pattern("cdfgeb", "abcdfg")
# |> IO.inspect()

# |> IO.inspect()
# |> bind_pattern("cagedb", "abcefg")
# |> bind_pattern("cagedb", "abdefg")
# |> bind_pattern("cagedb", "abcdfg")
# |> IO.inspect()
