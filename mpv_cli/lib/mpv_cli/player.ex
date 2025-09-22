defmodule MpvCli.Player do
    # Ensure agent is started before any use
  defp ensure_agent_started do
    case Process.whereis(__MODULE__) do
      nil -> Agent.start_link(fn -> nil end, name: __MODULE__)
      _ -> :ok
    end
  end

  def play_song(%{"title" => title, "url" => url}) do
    ensure_agent_started()
    IO.puts("Now playing: #{title}\n")
    mpv_path = System.find_executable("mpv") || "/opt/homebrew/bin/mpv"

    port = Port.open({:spawn_executable, mpv_path}, [
      :binary,
      args: ["--no-video", url]
    ])

   #  Get the OS PID from the port after it's created.

    os_pid = Port.info(port, :os_pid)

    # Store port, title, and the retrieved os_pid in the agent's state.
    Agent.update(__MODULE__, fn _ -> %{port: port, title: title, os_pid: os_pid} end)

    # Start the port listener in a separate process
    Task.start(fn -> listen_to_port(port) end)

  end

  def stop do
    ensure_agent_started()

    case Agent.get(__MODULE__, & &1) do
      nil ->
        IO.puts("No song is currently playing.")

      %{port: port, os_pid: os_pid} when is_port(port) and is_integer(os_pid) ->
        Port.close(port)
        # System.cmd("kill", ["-9", Integer.to_string(os_pid)])
        System.cmd("kill", [Integer.to_string(os_pid)])
        IO.puts("Stopped playback and killed mpv process with PID #{os_pid}")
        Agent.update(__MODULE__, fn _ -> nil end)

      %{port: port} when is_port(port) ->
        Port.close(port)
        IO.puts("Stopped playback (no PID found).")
        Agent.update(__MODULE__, fn _ -> nil end)
    end
  end

  def status do
    ensure_agent_started()

    case Agent.get(__MODULE__, & &1) do
      nil ->
        IO.puts("No song is currently playing.")

      %{port: port, title: title} ->
        if Port.info(port) do
          IO.puts("Currently playing: #{String.trim(title)}, in Port: #{inspect(port)}")
        else
          IO.puts("Port is inactive or exited.")
          Agent.update(__MODULE__, fn _ -> nil end)
        end
    end
  end

  defp listen_to_port(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        listen_to_port(port)

      {^port, {:exit_status, status}} ->
        IO.puts("mpv exited with status #{status}")
        Agent.update(__MODULE__, fn _ -> nil end)
    end
  end

  defp loop do
    IO.puts("Press Ctrl+Q to stop the player")

    case IO.getn("", 1) do
      <<17>> ->  # Ctrl+Q
        IO.puts("\nStopping player (Ctrl+Q pressed)...")
        MpvCli.Player.stop()
        System.halt(0)
      _ ->
        :timer.sleep(100)
        loop()
    end
  end
end
