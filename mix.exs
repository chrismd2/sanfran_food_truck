defmodule SanfranFoodTruck.MixProject do
  use Mix.Project

  def project do
    [
      app: :sanfran_food_truck,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:csv, "~> 3.2"},
      {:math, "~> 0.7.0"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:postgrex, ">= 0.0.0"},
    ]
  end
end
