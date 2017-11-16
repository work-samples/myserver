defmodule Myserver.Web do
  use Plug.Router
  require Logger
  require EEx

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(
      __MODULE__,
      [],
      [port: Application.get_env(:myserver, :port)])
  end

  get "/" do
    send(conn, 200, %{version: Myserver.version})
  end

  match "*glob" do
    send(
      conn,
      404,
      %{
          error: "unknown_resource",
          reason: "/#{glob |> Enum.join("/")} is not the path you are looking for",
       }
    )
  end

  defp send(conn, status_code, raw_body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, Poison.encode!(raw_body))
  end

end