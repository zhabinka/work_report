defmodule WorkReport.Parser do
  alias WorkReport.Model.{MonthReport, DayReport, Task}

  def parse_year(data_per_year) do
    data_per_year
    |> String.trim()
    |> String.split("\n\n\n")
    |> Enum.map(&parse_month/1)
  end

  def parse_month(data_per_month) do
    ["# " <> month | data_per_days] = data_per_month |> String.trim() |> String.split("\n\n")
    days = Enum.map(data_per_days, &parse_day/1)

    %MonthReport{month: month, month_num: MonthReport.get_month_num(month), days: days}
  end

  def parse_day(data_per_day) do
    ["## " <> day | data_per_tasks] = data_per_day |> String.trim() |> String.split("\n")
    tasks = Enum.map(data_per_tasks, &parse_task/1)

    %DayReport{day: day, day_num: DayReport.get_day_num(day), tasks: tasks}
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
