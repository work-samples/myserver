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

  get "/profile" do
    case get_req_header(conn, "authorization") do
      ["Bearer abc123"] -> send(conn, 200, %{answer: 42})
      ["Bearer def456"] -> send(conn, 403, %{error: "Forbidden", reason: "No access to this resource"})
      _ -> send(conn, 401, %{error: "Unauthorized", reason: "Invalid credentials"})
    end
  end

  post "/oauth2/token" do
    case conn.body_params["grant_type"] do
      "refresh_token" -> refresh_token(conn)
      "authorization_code" -> authorization_code(conn)
      _ -> send(conn, 404, %{error: "unknown_token", data: conn.body_params})
    end
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

  def refresh_token(conn) do
    case conn.body_params["refresh_token"] do
      "good1234" -> send(conn, 200, good_token())
      _ -> send(conn, 404, %{error: "unknown_refresh", data: conn.body_params})
    end
  end

  def authorization_code(conn) do
    case conn.body_params["code"] do
      "code1234" -> send(conn, 200, good_token())
      _ -> send(conn, 404, %{error: "unknown_code", data: conn.body_params})
    end
  end

  def good_token() do
    %{"access_token" => "access1234",
      "expires_in" => 1800,
      "refresh_token" => "good1234",
      "token_type" => "Bearer"}
  end

end