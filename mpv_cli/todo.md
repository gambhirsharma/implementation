
# TODO:
- [ ] Run the mpv in in an elixir process
- [ ] Run the songs in loop
- [ ] Fetch the title first before playing the songs.

---
<details>
    <summary>Even after terminating the `./mpv_cli` using `ctrl+c` the song is still playing.</summary>

   🔍 How System.cmd/3 Works
In Elixir, this function:

```bash
System.cmd("mpv", ["--no-video", url], stderr_to_stdout: true)
```

does not spawn a subprocess that you control in real-time. It:

- Spawns an OS process (mpv)
- Waits until mpv exits
- Collects all output (stdout and stderr) after it’s done
- Returns {output, exit_code}

</details>

- [ChatGPT reponse](https://chatgpt.com/share/683b7de2-365c-800b-bd0f-53475583ad51)
