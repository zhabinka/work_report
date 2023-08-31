defmodule WorkReport.MixProject do
  use Mix.Project

  def project do
    [
      app: :work_report,
      version: "0.1.0",
      elixir: "~> 1.15.3",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: WorkReport, app: nil]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false}
    ]
  end
end
