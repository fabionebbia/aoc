defmodule Submarine do
  defstruct aim: 0, depth: 0, h_pos: 0

  def new do
    %Submarine{}
  end
end

defmodule Day2 do
  @doc """
    Parses input commands.

      iex> Day2.parse_input(\"""
      ...>forward 5
      ...>down 5
      ...>forward 8
      ...>up 3
      ...>down 8
      ...>forward 2
      ...>\""")
      [
        {:forward, 5},
        {:down, 5},
        {:forward, 8},
        {:up, 3},
        {:down, 8},
        {:forward, 2}
      ]

  """
  def parse_input(commands) when is_binary(commands) do
    commands
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [command, amount] = String.split(line, " ")
      {String.to_atom(command), String.to_integer(amount)}
    end)
  end

  @doc """
    Executes commands on a submarine.

      iex> Day2.pilot_part_1(Submarine.new(), [
      ...>  {:forward, 5},
      ...>  {:down, 5},
      ...>  {:forward, 8},
      ...>  {:up, 3},
      ...>  {:down, 8},
      ...>  {:forward, 2}
      ...>])
      %Submarine{aim: 0, depth: 10, h_pos: 15}

  """
  def pilot_part_1(%Submarine{} = submarine, []) do
    submarine
  end

  def pilot_part_1(%Submarine{depth: depth} = submarine, [{:down, amount} | commands]) do
    %{submarine | depth: depth + amount} |> pilot_part_1(commands)
  end

  def pilot_part_1(%Submarine{depth: depth} = submarine, [{:up, amount} | commands]) do
    %{submarine | depth: depth - amount} |> pilot_part_1(commands)
  end

  def pilot_part_1(%Submarine{h_pos: h_pos} = submarine, [{:forward, amount} | commands]) do
    %{submarine | h_pos: h_pos + amount} |> pilot_part_1(commands)
  end

  @doc """
    Executes commands on a submarine.

      iex> Day2.pilot_part_2(Submarine.new(), [
      ...>  {:forward, 5},
      ...>  {:down, 5},
      ...>  {:forward, 8},
      ...>  {:up, 3},
      ...>  {:down, 8},
      ...>  {:forward, 2}
      ...>])
      %Submarine{aim: 10, depth: 60, h_pos: 15}

  """
  def pilot_part_2(%Submarine{} = submarine, commands) do
    Enum.reduce(commands, submarine, fn command, acc -> execute(acc, command) end)
  end

  defp execute(%Submarine{aim: aim} = submarine, {:down, amount}) do
    %{submarine | aim: aim + amount}
  end

  defp execute(%Submarine{aim: aim} = submarine, {:up, amount}) do
    %{submarine | aim: aim - amount}
  end

  defp execute(%Submarine{aim: aim, depth: depth, h_pos: h_pos} = submarine, {:forward, amount}) do
    %{submarine | h_pos: h_pos + amount, depth: depth + aim * amount}
  end
end
