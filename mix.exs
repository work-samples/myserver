defmodule Myserver.Mixfile do
  use Mix.Project

  @name    :myserver
  @version "0.1.0"

  @deps [
    {:ex_doc, ">= 0.0.0", only: [:dev] },
    {:mix_test_watch, "~> 0.5", only: [:test]},
    {:cowboy, "~> 1.1"},
    {:poison, "~> 3.1"},
    {:plug, "~> 1.4"},
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      elixir:  ">= 1.5.2",
      deps:    @deps,
      build_embedded:  in_production,
    ]
  end

  def application do
    [
      mod: {Myserver, []},
      extra_applications: [
        :logger,
      ]
    ]
  end

end
