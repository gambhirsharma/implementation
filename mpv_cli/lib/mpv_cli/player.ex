defmodule MpvCli.Player do
  def play_song(%{"title" => title, "url" => url}) do
    IO.puts("Now playing: #{title}\n")
    mpv_path = System.find_executable("mpv") || "/opt/homebrew/bin/mpv"

    port = Port.open({:spawn_executable, mpv_path}, [
      :binary,
      args: ["--no-video", url]
    ])

    Agent.update(__MODULE__, fn _ -> port end)
    listen_to_port(port)
  end

  def stop do
    case Agent.get(__MODULE__, & &1) do
      nil -> IO.puts("No song is currently playing.")
      port ->
        Port.close(port)
        IO.puts("Stopped playback.")
        Agent.update(__MODULE__, fn _ -> nil end)
    end
  end

  defp listen_to_port(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        listen_to_port(port)

      {^port, {:exit_status, status}} ->
        IO.puts("mpv exited with status #{status}")
    end
  end
end

Agent.start_link(fn -> nil end, name: MpvCli.Player)
