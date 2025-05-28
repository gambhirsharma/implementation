defmodule HttpServer.Web do
  use GenServer  # Similar to creating a class in JS

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    routes = [
      {"/", :cowboy_static, {:priv_file, :http_server_elixir_cowsay, "index.html"}},
      {"/hello", HelloHandler, []},
      {"/api/users", UserHandler, []}
    ]

    dispatch = :cowboy_router.compile([
      {:_, routes}
    ])

    {:ok, _} = :cowboy.start_clear(
      :http_listener,
      [{:port, 8080}],
      %{env: %{dispatch: dispatch}}
    )

    {:ok, %{}}
  end
end
