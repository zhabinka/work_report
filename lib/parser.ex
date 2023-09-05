defmodule WorkReport.Parser do
  alias WorkReport.Model.{MonthReport, DayReport, Task}

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

  def parse_year(data_per_year) do
    data_per_year
    |> String.trim()
    |> String.split("\n\n\n")
    |> Enum.map(&parse_month/1)
  end

  def parse_month(data_per_month) do
    ["# " <> month | data_per_days] = data_per_month |> String.trim() |> String.split("\n\n")
    {month_num, _} = Enum.find(@months, fn {_k, v} -> v == month end)
    days = Enum.map(data_per_days, &parse_day/1)

    %MonthReport{month: month, month_num: month_num, days: days}
  end

  def parse_day(data_per_day) do
    ["## " <> day | data_per_tasks] = data_per_day |> String.trim() |> String.split("\n")
    {day_num, _} = Integer.parse(day)
    tasks = Enum.map(data_per_tasks, &parse_task/1)

    %DayReport{day: day, day_num: day_num, tasks: tasks}
  end

  @spec parse_task(String.t()) :: map()
  def parse_task(task) do
    [_, category] = Regex.run(~r/\[(.*)\]/, task)
    # [category] = Regex.run(~r/^\[.*\]/, task)
    [description] = Regex.run(~r/(?<=\]\s).*?(?=\s-\s)/, task)
    [time] = Regex.run(~r/(?<=\s-\s).*/, task)
    %Task{category: category, description: description, time: parse_time(time)}
  end

  @spec parse_time(String.t()) :: non_neg_integer()
  def parse_time(time) do
    time
    |> String.split(" ")
    |> Enum.reduce(0, fn bit, acc ->
      case Integer.parse(bit) do
        {hours, "h"} -> acc + hours * 60
        {minutes, "m"} -> acc + minutes
        :error -> acc
      end
    end)
  end
end
