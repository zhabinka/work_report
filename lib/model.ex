defmodule WorkReport.Model do
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
