defmodule Myserver.Mixfile do
  use Mix.Project

  @app    :myserver
  @git_url "https://github.com/work-samples/myserver"
  @home_url @git_url
  @version "0.0.3"

  @deps [
    {:ex_doc, ">= 0.0.0", only: [:dev] },
    {:mix_test_watch, "~> 0.5", only: [:test]},
    {:cowboy, "~> 1.1"},
    {:poison, "~> 3.1"},
    {:plug, "~> 1.4"},
    {:version_tasks, "~> 0.10"},
  ]

  @package [
    name: @app,
    files: ["lib", "mix.exs", "README*", "README*", "LICENSE*"],
    maintainers: ["Andrew Forward"],
    licenses: ["MIT"],
    links: %{"GitHub" => @git_url}
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @app,
      version: @version,
      elixir:  ">= 1.5.2",
      name: "Myserver",
      description: "A sample server for testing RESTful API clients through HTTP",
      package: @package,
      source_url: @git_url,
      homepage_url: @home_url,
      docs: [main: "Myserver",
             extras: ["README.md"]],
      build_embedded:  in_production,
      start_permanent:  in_production,
      deps:    @deps,
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
