defmodule HttpServerElixir do
  @moduledoc """
  """

  @doc """
  Starts a server on the given port.
  ## Examples
    iex> HttpServerElixir.start(8080) 
  """
  def start(port) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Listening on port #{port}")

    accept_connection(listen_socket)
  end

  @doc """
  Accepts a connection.
  """
  def accept_connection(listen_socket) do
    IO.puts("Accepting connections...\n")
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    IO.puts("Connection accepted\n")
    process_request(socket)
    accept_connection(listen_socket)
  end

  @doc """
  Processes a request.
  """
  def process_request(client_socket) do
    IO.puts("Processing request...\n")

    client_socket
    |> read_request
    |> create_response
    |> write_response(client_socket)
  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    request
  end

  def create_response(_request) do
    body = "Hello, World!"

    """
    HTTP/1.1 200 OK\r
    Content-Type: text/plain\r
    Content-Length: #{byte_size(body)}\r
    \r
    #{body}
    """
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)
    IO.puts("Response: #{response}\n")
    :gen_tcp.close(client_socket)
  end
end
