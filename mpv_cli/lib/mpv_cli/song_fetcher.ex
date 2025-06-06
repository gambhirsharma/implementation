defmodule MpvCli.SongFetcher do
  def sanitize_song_list(input) do
    songs = if is_list(input), do: input, else: [input]

    songs
    |> Task.async_stream(&fetch_song/1, max_concurrency: 4)
    |> Enum.map(fn {:ok, s} -> s end)
  end

  defp fetch_song(%{"url" => url}), do: fetch_song(url)
  defp fetch_song(url) when is_binary(url) do
    {title, 0} = System.cmd("yt-dlp", ["--get-title", url], stderr_to_stdout: true)
    %{"title" => title, "url" => url}
  end
end
