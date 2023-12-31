defmodule WorkReport do
  @moduledoc """
  # DONE-list analyser
  """
  @name "Work Report"
  @version "1.0.0"

  import WorkReport.Parser
  import WorkReport.Formatter

  def main(args \\ []) do
    IO.inspect(parse_args(args))

    case parse_args(args) do
      {[month: month, day: day], [path], []} -> make_report(path)
      {[help: true], [], []} -> help()
      {[version: true], [], []} -> IO.puts(@name <> " v" <> @version)
      _ -> IO.puts(:jopa)
    end
  end

  def parse_args(args) do
    OptionParser.parse(
      args,
      strict: [month: :string, day: :string, help: :boolean, version: :boolean],
      aliases: [m: :month, d: :day]
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

  def make_report(path, options \\ %{}) do
    IO.puts("make_report #{path}")

    path
    |> parse()
    |> build_tree()
    |> build_report()
  end

  def parse(path) do
    IO.puts("parser #{path}")

    case File.read(path) do
      {:ok, source} -> source
      {:error, error} -> error
    end
  end
end
