defmodule WorkReport.Model do
  defmodule MonthReport do
    @type t :: %__MODULE__{
            month: String.t(),
            month_num: non_neg_integer(),
            days: [DayReport.t()]
          }

    defstruct [:month, :month_num, :days]

    @spec months() :: map()
    def months do
      %{
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
    end

    @spec get_month_num(String.t()) :: Range.t(1..12)
    def get_month_num(month) do
      case Enum.find(months(), fn {_k, v} -> v == month end) do
        {num, _} -> num
        nil -> raise RuntimeError, message: "unknown month \"#{month}\""
      end
    end
  end

  defmodule DayReport do
    @type t :: %__MODULE__{
            day: String.t(),
            day_num: non_neg_integer(),
            tasks: [Task.t()]
          }

    @enforce_keys [:day, :day_num, :tasks]

    defstruct [:day, :day_num, :tasks]

    @spec get_day_num(String.t()) :: Range.t(1..31)
    def get_day_num(day) do
      case Integer.parse(day) do
        {num, _} when num in 1..31 -> num
        _ -> raise RuntimeError, message: "unknown day \"#{day}\""
      end
    end
  end

  defmodule Task do
    @type t :: %__MODULE__{
            category: String.t(),
            description: String.t(),
            time: non_neg_integer()
          }

    @enforce_keys [:category, :description, :time]

    defstruct [:category, :description, :time]
  end
end
