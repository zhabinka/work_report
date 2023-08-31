defmodule WorkReport do
  @moduledoc """
  # DONE-list analyser
  """

  @doc """
  Hello world.

  ## Examples

      iex> WorkReport.hello()
      :world

  """

  @name "Work Report"
  @version "1.0.0"

  def main(args \\ []) do
    IO.puts("args #{}")
    IO.inspect(args)
    IO.inspect(parse_args(args))

    case parse_args(args) do
      {[help: true], [], []} -> help()
      {[version: true], [], []} -> IO.puts(@version)
      _ -> IO.puts(:jopa)
    end
  end

  def parse_args(args) do
    OptionParser.parse(
      args,
      strict: [xz: :string, help: :boolean, version: :boolean]
    )
  end

  def help() do
    IO.puts("""
    USAGE:
        work_report [OPTIONS] <path/to/report.md>
    OPTIONS:
        -m, --month <M>  Show report for month (int), current month by default
        -d, --day <D>    Show report for day (int), current day by default
        -v, --version    Show version
        -h, --help       Show this help message
    """)
  end
end
