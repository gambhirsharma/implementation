defmodule MpvCli.SongFetcher do
  def sanitize_song_list(input) do
    songs = if is_list(input), do: input, else: [input]

    songs
    |> Task.async_stream(&fetch_song/1, max_concurrency: 4)
    |> Enum.map(fn {:ok, s} -> s end)
  end

  defp fetch_song(%{"url" => url}), do: fetch_song(url)
  defp fetch_song(url) when is_binary(url) do
    case System.cmd("yt-dlp", ["--get-title", url], stderr_to_stdout: true) do
      {title, 0} ->
        %{"title" => String.trim(title), "url" => url}
      {error_output, _exit_code} ->
        # If yt-dlp fails, use the URL as title or a default title
        IO.puts("Warning: Failed to fetch title for #{url}: #{String.slice(error_output, 0, 100)}...")
        %{"title" => "Unknown Title", "url" => url}
    end
  rescue
    _ ->
      # Handle any other errors (like network issues)
      IO.puts("Error: Could not process URL #{url}")
      %{"title" => "Error - Could not fetch", "url" => url}
  end
end
