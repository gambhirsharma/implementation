
  "https://www.youtube.com/watch?v=JVtKEX90SZ0",

mpv_path = System.find_executable("mpv")
Port.open({:spawn_executable, mpv_path}, [:binary, args: ["--no-video", "https://www.youtube.com/watch?v=JVtKEX90SZ0"]])
