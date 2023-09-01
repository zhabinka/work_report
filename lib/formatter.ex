defmodule WorkReport.Formatter do
  @categories ["COMM", "DEV", "OPS", "DOC", "WS", "EDU"]

  def build_report(tree, month_num \\ 5, day_num \\ 4) do
    [%{month: current_month, days: days}] =
      Enum.filter(tree, fn %{month_num: num} -> month_num == num end)

    [%{day: day, tasks: tasks}] =
      Enum.filter(days, fn %{day_num: num} -> day_num == num end)

    grouped_tasks =
      Enum.reduce(days, [], fn %{tasks: tasks}, acc -> acc ++ tasks end)
      |> Enum.group_by(fn %{category: category} -> category end)

    time_per_category =
      for {k, v} <- grouped_tasks, into: %{}, do: {k, calc_total_day_time(v)}

    month_output =
      Enum.reduce(@categories, %{}, fn cat, acc -> Map.put(acc, cat, 0) end)
      |> Map.merge(time_per_category)
      |> Enum.reduce([], fn {cat, time}, acc -> acc ++ [format_category({cat, time})] end)
      |> Enum.join("\n")

    day_output = tasks |> Enum.map(&formate_task/1) |> Enum.join("\n")
    total_day_time = calc_total_day_time(tasks)

    total_month_time =
      Enum.reduce(days, 0, fn %{tasks: tasks}, acc -> calc_total_day_time(tasks) + acc end)

    total_month_days = length(days)
    average_month_time = div(total_month_time, total_month_days)

    ("Day: #{day_num} #{day}\n#{day_output}\n   " <>
       "Total: #{format_time(total_day_time)}\n" <>
       "Month: #{current_month}\n" <>
       "#{month_output}\n" <>
       "Total: #{format_time(total_month_time)}, " <>
       "Days: #{total_month_days}, " <>
       "Avg: #{format_time(average_month_time)}")
    |> IO.puts()
  end

  def calc_total_day_time(tasks) do
    Enum.reduce(tasks, 0, fn %{time: time}, acc -> time + acc end)
  end

  def format_category({cat, time}) do
    " - #{cat}: #{format_time(time)}"
  end

  @spec formate_task(map()) :: String.t()
  def formate_task(task) do
    %{time: time, description: description, category: category} = task
    " - #{category}: #{description} - #{format_time(time)}"
  end

  @spec format_time(non_neg_integer()) :: String.t()
  def format_time(minutes) do
    hours = div(minutes, 60)

    cond do
      hours == 0 -> "#{minutes}m"
      true -> "#{hours}h #{rem(minutes, 60)}m"
    end
  end
end
