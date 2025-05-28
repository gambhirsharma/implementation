defmodule HelloHandler do
  @behaviour :cowboy_handler

  def init(req, state) do
    reply = :cowboy_req.reply(
      200,
      %{"content-type" => "text/plain"},
      "Hello, World!",
      req
    )
    {:ok, reply, state}
  end
end

defmodule UserHandler do
  @behaviour :cowboy_rest

  def init(req, state), do: {:cowboy_rest, req, state}

  def content_types_provided(req, state) do
    {[{"application/json", :get_json_users}], req, state}
  end

  def get_json_users(req, state) do
    users = [
      %{id: 1, name: "Alice"},
      %{id: 2, name: "Bob"}
    ]
    {Jason.encode!(users), req, state}
  end
end


defmodule DemoHandler do
  def init(req, state) do
    
  end
end
