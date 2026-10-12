"""Save a Wayland clipboard PNG into Nemo's current directory."""

from datetime import datetime
from pathlib import Path
import subprocess
import sys


def main(directory):
    try:
        image = subprocess.run(
            ["wl-paste", "--no-newline", "--type", "image/png"],
            capture_output=True, check=True,
        ).stdout
        if not image.startswith(b"\x89PNG\r\n\x1a\n"):
            raise ValueError("The clipboard does not contain a PNG screenshot.")

        prompt = subprocess.run(
            ["zenity", "--entry", "--title=Paste Screenshot",
             "--text=Filename (leave blank to use a timestamp):"],
            capture_output=True, text=True,
        )
        if prompt.returncode != 0:
            return
        name = prompt.stdout.strip() or datetime.now().strftime(
            "Screenshot-%Y-%m-%d_%H-%M-%S-%f"
        )
        if name in (".", "..") or "/" in name or "\x00" in name:
            raise ValueError("Enter a filename, without a folder path.")
        if not name.lower().endswith(".png"):
            name += ".png"
        target = Path(directory) / name
        # Exclusive creation protects existing files, including symlinks.
        with target.open("xb") as output:
            try:
                output.write(image)
            except OSError:
                target.unlink()
                raise
    except subprocess.CalledProcessError:
        subprocess.run(["zenity", "--error", "--text=No PNG screenshot in the clipboard."])
    except (OSError, ValueError) as error:
        subprocess.run(["zenity", "--error", f"--text=Could not save screenshot: {error}"])


if __name__ == "__main__":
    main(sys.argv[1])
