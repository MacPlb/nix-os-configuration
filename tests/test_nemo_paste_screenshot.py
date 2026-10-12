import importlib.util
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch


spec = importlib.util.spec_from_file_location(
    "paste_screenshot",
    Path(__file__).resolve().parents[1]
    / "modules/home/scripts/nemo-paste-screenshot.py",
)
script = importlib.util.module_from_spec(spec)
spec.loader.exec_module(script)
PNG = b"\x89PNG\r\n\x1a\nclipboard data"


class PasteScreenshotTests(unittest.TestCase):
    def run_paste(self, directory, name="", cancel=False, image=PNG):
        with patch.object(script.subprocess, "run", side_effect=[
            subprocess.CompletedProcess([], 0, stdout=image),
            subprocess.CompletedProcess([], int(cancel), stdout=name),
            subprocess.CompletedProcess([], 0),
        ]) as run:
            script.main(directory)
        return run

    def test_name_with_spaces(self):
        with tempfile.TemporaryDirectory(prefix="nemo folder ") as folder:
            self.run_paste(folder, "my screenshot\n")
            self.assertEqual((Path(folder) / "my screenshot.png").read_bytes(), PNG)

    def test_empty_name_uses_timestamp(self):
        with tempfile.TemporaryDirectory() as folder:
            self.run_paste(folder, "\n")
            files = list(Path(folder).iterdir())
            self.assertEqual(len(files), 1)
            self.assertRegex(files[0].name, r"^Screenshot-\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}-\d{6}\.png$")
            self.assertEqual(files[0].read_bytes(), PNG)

    def test_existing_file_is_preserved(self):
        with tempfile.TemporaryDirectory() as folder:
            target = Path(folder) / "existing.png"
            target.write_bytes(b"original")
            run = self.run_paste(folder, "existing.png")
            self.assertEqual(target.read_bytes(), b"original")
            self.assertIn("--error", run.call_args.args[0])

    def test_cancel_and_invalid_names_create_nothing(self):
        with tempfile.TemporaryDirectory() as folder:
            self.run_paste(folder, "cancelled", cancel=True)
            for name in ["../escape", "/absolute", ".", ".."]:
                run = self.run_paste(folder, name)
                self.assertIn("--error", run.call_args.args[0])
            self.assertEqual(list(Path(folder).iterdir()), [])

    def test_non_image_clipboard_is_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            run = self.run_paste(folder, image=b"text")
            self.assertIn("--error", run.call_args.args[0])
            self.assertEqual(list(Path(folder).iterdir()), [])


if __name__ == "__main__":
    unittest.main()
