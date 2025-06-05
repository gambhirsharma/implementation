defmodule MpvCli do
@moduledoc "A simple music player CLI using mpv and data.json"
  @json_file "data2.json"

  # This is the CLI entry point for escript
  def main(_args), do: main()
  def main do
    case File.read(@json_file) do
      {:ok, content} ->
        case Jason.decode(content) do
          # {:ok, songs} -> choose_song(songs)
          {:ok, songs} -> sanitize_song_list(songs)
          {:error, _} -> IO.puts("Invalid JSON format.")
        end

      {:error, _} ->
        IO.puts("Could not read #{@json_file}")
    end
  end

  defp sanitize_song_list(input) do
    IO.puts("Sanitizing song list...")

    # Convert input to list if it's not already
    songs = if is_list(input), do: input, else: [input]

    # Process each YouTube URL to get title
    processed_songs = Enum.map(songs, fn
      %{"url" => url} ->
        {title, 0} = System.cmd("yt-dlp", ["--get-title", url], stderr_to_stdout: true)
        %{"title" => title, "url" => url}
      url when is_binary(url) ->
        {title, 0} = System.cmd("yt-dlp", ["--get-title", url], stderr_to_stdout: true)
        %{"title" => title, "url" => url}
    end)

    # Save the processed songs back to the JSON file
    case Jason.encode(processed_songs, pretty: true) do
      {:ok, json} ->
        File.write(@json_file, json)
        IO.puts("Successfully updated #{@json_file} with titles")
        choose_song(processed_songs)
      {:error, _} ->
        IO.puts("Failed to encode songs to JSON")
    end
  end

  defp choose_song(songs) do
    Enum.with_index(songs, 1)
    |> Enum.each(fn {%{"title" => title}, i} ->
      IO.puts("#{i}. #{title}")
    end)

    IO.puts("\nChoose a song number:")
    input = IO.gets("> ") |> String.trim()

    case Integer.parse(input) do
      {index, _} when index in 1..length(songs) ->
        play_song(Enum.at(songs, index - 1))

      _ ->
        IO.puts("Invalid input.")
    end
  end

  defp play_song(%{"title" => title, "url" => url}) do
    IO.puts("Now playing: #{title}\n")
    port = Port.open({:spawn_executable, "/usr/local/bin/mpv"}, [
      :binary,
      args: ["--no-video", url],
      exit_status: true
    ])
    listen_to_port(port)
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

  defp parse_output(output) do
    for line <- String.split(output, "\n") do
      cond do
        String.contains?(line, "Audio") -> IO.puts("● #{line}")
        String.contains?(line, "File tags:") -> IO.puts(line)
        String.match?(line, ~r/^\s+\w+:/) -> IO.puts("  #{String.trim(line)}")
        String.contains?(line, "AO:") or String.contains?(line, "A:") -> IO.puts(line)
        true -> :ok
      end
    end
  end
end
