defmodule MpvCli do
@moduledoc "A simple music player CLI using mpv and data.json"
  @json_file "data.json"

  # This is the CLI entry point for escript
  def main(_args), do: main()
  def main do
    case File.read(@json_file) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, songs} -> choose_song(songs)
          {:error, _} -> IO.puts("Invalid JSON format.")
        end

      {:error, _} ->
        IO.puts("Could not read #{@json_file}")
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
    {output, _code} = System.cmd("mpv", ["--no-video", url], stderr_to_stdout: true)
    parse_output(output)
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
