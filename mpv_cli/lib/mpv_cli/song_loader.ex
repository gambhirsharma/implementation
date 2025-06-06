defmodule MpvCli.SongLoader do

    @json_file "data2.json"
    @santized_file "final_data.json"

  def load_songs do
    case File.read(@json_file) do
      {:ok, content} -> 
        case Jason.decode(content) do 
          {:ok, urls} when is_list(urls) -> {:ok, urls}
          _ -> {:ok, []}
        end
      {:error, _} ->
      IO.puts("Could not read #{@json_file}")
        []
    end
  end

  def save_song(songs) do
    case Jason.encode(songs, pretty: true) do
      {:ok, json} -> File.write(@santized_file, json)
      err -> err
  end
end

  # defp process_song(songs) do
  #   Enum.map(songs, fn
  #     %{"url" => url} ->
  #     {title, 0} = System.cmd("yt-dlp", ["--get-title", url], stderr_to_stdout: true)
  #     %{"title" => String.trim(title), "url" => url}
  #     url when is_binary(url) ->
  #     {title, 0} = System.cmd("yt-dlp", ["--get-title", url], stderr_to_stdout: true)
  #     %{"title" => String.trim(title), "url" => url}
  #   end)
  # end

end

# old code
#     case File.read(@json_file) do
    #   {:ok, content} ->
    #     case Jason.decode(content) do
    #       # {:ok, songs} -> choose_song(songs)
    #       {:ok, songs} -> sanitize_song_list(songs)
    #       {:error, _} -> IO.puts("Invalid JSON format.")
    #     end
    #
    #   {:error, _} ->
    #     IO.puts("Could not read #{@json_file}")
    # end
    #
