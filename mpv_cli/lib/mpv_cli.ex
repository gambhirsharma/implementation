defmodule MpvCli do
  @syncIt "data2.json"
  @hardCore "final_data.json"

@moduledoc "A simple music player CLI using mpv and data.json"
  # @json_file "data2.json"
  alias MpvCli.{SongLoader, SongFetcher, Player}

  # This is the CLI entry point for escript
  @doc """
  Main entry point for the CLI application.
  """
  # def main(_args), do: main()
  def main(args \\ []) do
    song =
    if Enum.member?(args, "--sync") do

      case SongLoader.load_songs(@syncIt) do
        {:ok, songs} ->
          IO.puts("Syncing and fetching song titles ...")
          santized = SongFetcher.sanitize_song_list(songs)
          SongLoader.save_song(santized)
          choose_song(santized)
        _ ->
          IO.puts("Could not load or parse song list")
          nil
      end
  else
    case SongLoader.load_songs(@hardCore) do
      {:ok, songs} ->
        IO.puts("Loading songs ...")

        santized =  SongFetcher.sanitize_song_list(songs)
        # SongLoader.save_song(santized)
        choose_song(santized)


        # NOTE: You can't pass list to IO.puts()

        # Enum.map(santized, fn %{"title"=> title, "url" => url}->
        #   IO.puts("Title: #{title}")
        #   IO.puts("URL: #{url}")
        # end)

        # IO.inspect(santized, label: "Sanitized Songs")
        # SongLoader.save_song(SantizedData)

        IO.puts("song are #{inspect(songs)}")

      _ ->
          IO.puts("Could not load or parse song list")
          nil
    end
  end

    if song do
        # Trap ctrl +c
        Process.flag(:trap_exit, true)
        IO.puts("Press Ctrl+C to stop the player")
        loop()
      end


  end
  defp choose_song([song | _]), do: Player.play_song(song)
  defp choose_song([]), do: IO.puts("no song to play")

  defp loop do
    case Agent.get(MpvCli.Player, & &1) do
      %{title: title} ->
        IO.puts("Now playing: #{String.trim(title)}")
      _ ->
        IO.puts("No song is currently playing")
    end

    receive do
      {:EXIT, _from, :shutdown} ->
        IO.puts("\n Shutting down...")
        Player.stop()
        System.halt(0)

      {:EXIT, _from, reason} ->
        IO.puts("\nError: #{inspect(reason)}")
        Player.stop()
        System.halt(1)

      _ ->
        :timer.sleep(1000)
        loop()
    end
  end
end
