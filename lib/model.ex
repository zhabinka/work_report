defmodule WorkReport.Model do
  defmodule MonthReport do
    @type t :: %__MODULE__{
            month: String.t(),
            month_num: non_neg_integer(),
            days: [DayReport.t()]
          }

    defstruct [:month, :month_num, :days]
  end

  defmodule DayReport do
    @type t :: %__MODULE__{
            day: String.t(),
            day_num: non_neg_integer(),
            tasks: [Task.t()]
          }

    @enforce_keys [:day, :day_num, :tasks]

    defstruct [:day, :day_num, :tasks]
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
