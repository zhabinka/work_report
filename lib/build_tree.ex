defmodule WorkReport.BuildTree do
  @months %{
    1 => "January",
    2 => "February",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December"
  }

  @days %{
    1 => "mon",
    2 => "tue",
    3 => "wed",
    4 => "thu",
    5 => "fri",
    6 => "sat",
    7 => "sun"
  }

  def build_tree(markdown) do
    markdown
    |> String.split("\n\n\n")
    |> Enum.map(&String.split(&1, "\n\n"))
    |> Enum.map(&build_month/1)
  end

  def build_month(raw) do
    ["# " <> month | items] = raw
    {month_num, _} = Enum.find(@months, fn {_k, v} -> v == month end)

    days =
      Enum.map(items, fn item ->
        item
        |> String.trim()
        |> String.split("\n")
        |> build_day
      end)

    %{month: month, month_num: month_num, days: days}
  end

  def build_day(raw) do
    ["## " <> day | tasks] = raw
    [day_of_month, day_of_week] = String.split(day, " ")
    processed_task = Enum.map(tasks, &build_task/1)
    %{day: day_of_week, day_num: String.to_integer(day_of_month), tasks: processed_task}
  end

  def build_task(raw) do
    [category] = Regex.run(~r/^\[.*\]/, raw)
    [description] = Regex.run(~r/(?<=\]\s).*?(?=\s-\s)/, raw)
    [time] = Regex.run(~r/(?<=\s-\s).*/, raw)
    %{category: category, description: description, time: time}
  end
end
