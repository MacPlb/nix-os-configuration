"""Nautilus right-click actions: Paste Screenshot (folder background) and Convert to GIF (videos).

Nautilus scripts only appear when files are selected, so this is a nautilus-python extension.
modules/features/nautilus.nix replaces the @…@ placeholders with the helpers' store paths.
"""

from gi.repository import GObject, Gio, Nautilus

PASTE_SCREENSHOT = "@pasteScreenshot@"
VIDEO_TO_GIF = "@videoToGif@"


def local_path(file_info):
    if file_info.get_uri_scheme() != "file":
        return None
    return file_info.get_location().get_path()


def run(argv):
    # GSubprocess reaps the child itself, so nothing waits on it here.
    Gio.Subprocess.new(argv, Gio.SubprocessFlags.NONE)


class FileActions(GObject.GObject, Nautilus.MenuProvider):
    def get_background_items(self, current_folder):
        directory = local_path(current_folder)
        if directory is None:
            return []
        item = Nautilus.MenuItem(
            name="FileActions::PasteScreenshot",
            label="Paste Screenshot",
            tip="Save the clipboard image here; leave the filename blank for a timestamp",
        )
        item.connect("activate", lambda _item: run([PASTE_SCREENSHOT, directory]))
        return [item]

    def get_file_items(self, files):
        paths = [local_path(f) for f in files]
        if not files or None in paths:
            return []
        if not all(f.get_mime_type().startswith("video/") for f in files):
            return []
        item = Nautilus.MenuItem(
            name="FileActions::ConvertToGif",
            label="Convert to GIF",
            tip="Save a GIF next to each selected video",
        )
        item.connect("activate", lambda _item: run([VIDEO_TO_GIF, *paths]))
        return [item]
