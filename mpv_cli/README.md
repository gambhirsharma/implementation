# MPV CLI

A simple music player CLI built using Elixir, `mpv`, and `data.json`. This project allows you to play songs from a JSON file containing song metadata (title and URL).

## Prerequisites

Before running this project, ensure you have the following installed:

1. **Elixir**: Version `~> 1.18` or higher.
2. **MPV Media Player**: A command-line media player. Install it using your system's package manager:
   - On macOS: `brew install mpv`
   - On Ubuntu/Debian: `sudo apt install mpv`
   - On Arch Linux: `sudo pacman -S mpv`
3. **JSON File**: A `data.json` file containing song metadata in the following format:
   ```json
   [
     {
       "title": "Song Title 1",
       "url": "https://example.com/song1.mp3"
     },
     {
       "title": "Song Title 2",
       "url": "https://example.com/song2.mp3"
     }
   ]
   ```

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd mpv_cli
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Compile the project:
   ```bash
   mix compile
   ```

## Running the Project

### Using Mix
Run the project directly using Mix:
```bash
mix run
```

### Using Escript
1. Build the escript executable:
   ```bash
   mix escript.build
   ```

2. Run the generated executable:
   ```bash
   ./mpv_cli
   ```

## How to Use

1. Ensure the `data.json` file is in the root directory of the project.
2. Run the project using one of the methods above.
3. The CLI will display a list of songs from the `data.json` file.
4. Enter the number corresponding to the song you want to play.
5. The selected song will start playing using `mpv`.

## Project Structure

- `lib/mpv_cli.ex`: The main module containing the CLI logic.
- `mix.exs`: The project configuration file.
- `data.json`: The JSON file containing song metadata (must be created by the user).

## Dependencies

This project uses the following dependencies:
- [Jason](https://hex.pm/packages/jason): A JSON library for Elixir.

