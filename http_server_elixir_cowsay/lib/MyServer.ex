defmodule MyServer.Application do
  use Application

  def start(_type, _args) do
    children = [
      {HttpServer.Web, []}
    ]

    opts = [strategy: :one_for_one, name: HttpServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
