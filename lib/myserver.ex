defmodule Myserver do
  use Application

  @version Mix.Project.config[:version]
  def version, do: @version

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Myserver.Web, []),
    ]

    opts = [strategy: :one_for_one, name: Myserver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
