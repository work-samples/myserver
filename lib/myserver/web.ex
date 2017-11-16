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
    send(conn, 200, return_data(Myserver.version, conn.query_params["user"]))
  end

  post "/" do
    send(conn, 201, return_data(conn.body_params["version"], conn.query_params["user"]))
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

  defp return_data(version, nil), do: %{version: version}
  defp return_data(version, user), do: %{version: version, user: user}

  defp send(conn, status_code, raw_body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, Poison.encode!(raw_body))
  end

end