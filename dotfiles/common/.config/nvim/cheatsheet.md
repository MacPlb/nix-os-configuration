# Neovim cheatsheet (LazyVim)

`<Space>` is the leader key. Press it and wait: a popup (which-key) lists every key that
follows it. `<Space>sk` searches all keys by name, `<Space>?` shows this buffer's keys.
This sheet: `F1` or `:Cheatsheet`. Full list: https://lazyvim.org/keymaps

`:Lazy` shows the plugins (they come from Nix, so no install/update there),
`:LazyExtras` describes the extras, `:LazyHealth` checks everything.

## Basics

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `Ctrl-s`            | Save                                           |
| `<Space>qq`         | Quit everything                                |
| `<Space>bd`         | Close buffer                                   |
| `Shift-h` / `Shift-l` | Previous / next buffer                       |
| `<Space>,`          | Open buffers                                   |
| `<Esc>`             | Clear search highlight                         |
| `Ctrl-h/j/k/l`      | Move between windows                           |
| `<Space>-` / `<Space>\|` | Split below / right                       |
| `Ctrl-/`            | Toggle a terminal                              |
| `<Space>e`          | File explorer (`a` add, `d` delete, `r` rename, `?` help) |
| `s`                 | Jump anywhere: type 2 letters, then the label (flash) |
| `za` / `zc` / `zo`  | Toggle / close / open fold                     |
| `<Space>qs`         | Restore the last session in this folder        |

## Hooked files (harpoon)

The bar at the very top always shows your hooked files, numbered; the open one is highlighted.

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>H`          | Hook the current file                          |
| `<Space>h`          | Menu: reorder or delete lines, `Enter` opens   |
| `<Space>1` … `9`    | Jump to hooked file 1–9                        |

## Finding

Root = the language server's project, else the git repository / solution / go.mod / flake
folder of the current file. In any finder: type to filter, `Enter` opens,
`Ctrl-v`/`Ctrl-s` opens in a split, `Ctrl-q` sends results to the quickfix list,
`Alt-h` shows hidden files, `Alt-i` ignored ones, `Esc` closes.

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space><Space>`    | Find file in root                              |
| `<Space>ff` / `fF`  | Files in root / current folder                 |
| `<Space>/` or `sg`  | Grep text in root (`sG`: current folder)       |
| `<Space>sw`         | Grep the word under cursor (or selection)      |
| `<Space>fr`         | Recent files                                   |
| `<Space>fc`         | Neovim config files                            |
| `<Space>sb`         | Lines in this file                             |
| `<Space>ss` / `sS`  | Symbols (classes, methods) in file / project   |
| `<Space>sr`         | Search and replace in files (grug-far)         |
| `<Space>sR`         | Reopen the last finder                         |
| `<Space>st`         | TODO/FIXME comments                            |
| `<Space>su`         | Undo history                                   |

## Code navigation (like Rider)

| Key                    | What it does                                |
| ---------------------- | ------------------------------------------- |
| `gd` or `F12`          | Go to definition                            |
| `gD`                   | Go to declaration                           |
| `gI`                   | Go to implementation                        |
| `gy`                   | Go to type definition                       |
| `gr` or `Shift-F12`    | Find usages                                 |
| `K`                    | Documentation popup (press again to enter)  |
| `]]` / `[[`            | Next / previous use of the word under cursor |
| `Ctrl-o` / `Ctrl-i`    | Jump back / forward                         |
| `<Space>cs`            | Symbol outline of the file                  |
| `<Space>ca` or `Alt-Enter` | Code action / quick fix                 |
| `<Space>cr` or `F2`    | Rename symbol everywhere (live preview)     |
| `<Space>uh`            | Toggle inlay hints (parameter names, types) |
| `<Space>cl`            | Language servers info                       |

Completion pops up while typing: `Enter` accepts, `Ctrl-n`/`Ctrl-p` move,
`Ctrl-Space` opens it, `Ctrl-e` closes it, `Tab` jumps to the next snippet field.

## Editing

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `gsa` / `gsd` / `gsr` | Add / delete / replace surrounding quotes, brackets… (`gsaiw"`) |
| `gc` / `gcc`        | Comment selection / line                       |
| `Alt-j` / `Alt-k`   | Move line (or selection) down / up             |
| `Ctrl-a` / `Ctrl-x` | Increment / decrement numbers, dates, true/false |
| `p` then `[y` / `]y` | Paste, then cycle through earlier yanks       |
| `<Space>p`          | Yank history                                   |
| `vaf` / `vif` / `vac` | Select a function / its body / a class       |

## Errors and warnings

Errors are shown at the end of the line and as signs in the left column.

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `]d` / `[d`         | Next / previous problem (`]e`/`[e`: errors only) |
| `<Space>cd`         | Full message of the problem under cursor       |
| `<Space>xx`         | All problems (open files for C#; build for the rest) |
| `<Space>xX`         | Problems in this file                          |
| `<Space>xQ`         | Build errors (quickfix list)                   |
| `<Space>ud`         | Turn diagnostics off / on                      |

## Formatting

Files are formatted on save (Nix: nixfmt, C#: CSharpier, Go: goimports + gofumpt,
Python: ruff, TS/JS/JSON/Markdown/YAML/CSS/HTML: prettier, Lua: stylua, shell: shfmt).

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>cf`         | Format file (or selection)                     |
| `<Space>uf` / `uF`  | Format on save off / on (everywhere / this buffer) |
| `<Space>cj`         | Pretty-print JSON with jq (works on huge files) |
| `<Space>cJ`         | Minify JSON with jq                            |

## Markdown

Markdown files are rendered in the editor (raw text comes back in insert mode).

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>cp`         | Live preview in the browser (toggle)           |
| `<Space>um`         | Toggle rendering in the editor                 |

## .NET

The C# server (Roslyn) starts when you open a `.cs` file and picks the solution itself;
`<Space>Ns` chooses another one. Build errors go to the quickfix list and open automatically.

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>Nb`         | Build solution                                 |
| `<Space>NB`         | Rebuild (no incremental)                       |
| `<Space>Nc`         | Clean                                          |
| `<Space>NR`         | Restore NuGet packages                         |
| `<Space>Nr`         | Run project in a terminal                      |
| `<Space>Nw`         | Run with hot reload (`dotnet watch`)           |
| `<Space>Ns`         | Choose the solution                            |

## Debugging (C#, Go, Python)

Starting a debug session opens the debug panels: variables, watches, call stack,
breakpoints and console. `F5` on C# builds the project first, then starts it.

| Key                    | What it does                                |
| ---------------------- | ------------------------------------------- |
| `F5` / `<Space>dc`     | Start / continue                            |
| `Shift-F5` / `<Space>dt` | Stop                                      |
| `F9` / `<Space>db`     | Toggle breakpoint                           |
| `<Space>dB`            | Conditional breakpoint                      |
| `F10` / `<Space>dO`    | Step over                                   |
| `F11` / `<Space>di`    | Step into                                   |
| `Shift-F11` / `<Space>do` | Step out                                 |
| `<Space>dC`            | Run to cursor                               |
| `<Space>dl`            | Run the last session again                  |
| `<Space>de`            | Evaluate expression (or selection)          |
| `<Space>dw`            | Peek value under cursor                     |
| `<Space>du`            | Show / hide the debug panels                |

## Tests (xUnit/NUnit/MSTest, Go, pytest, Rust)

Results are shown next to each test: ✔ passed, ✖ failed.

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>tr`         | Run the test under the cursor                  |
| `<Space>tt`         | Run all tests in the file                      |
| `<Space>tT`         | Run all test files                             |
| `<Space>td`         | Debug the test under the cursor                |
| `<Space>tl`         | Run the last test again                        |
| `<Space>tS`         | Stop                                           |
| `<Space>ts`         | Test explorer (`r` run, `d` debug, `o` output) |
| `<Space>to`         | Output of the test under cursor                |
| `<Space>tO`         | Output panel                                   |
| `<Space>tw`         | Re-run the file's tests on every save          |

## Git

Changed lines are marked in the left column.

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>gg`         | lazygit                                        |
| `<Space>gs`         | Changed files                                  |
| `<Space>gl`         | Log                                            |
| `<Space>gb`         | Who changed the current line (blame)           |
| `]h` / `[h`         | Next / previous changed block (hunk)           |
| `<Space>ghs` / `ghr` | Stage / reset the hunk                        |
| `<Space>ghp`        | Preview the hunk                               |

## Other languages

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>cv`         | Python: choose the virtualenv                  |
| `<Space>D`          | SQL: database browser (dadbod)                 |
| `<Space>cR`         | Rust: code action from rust-analyzer           |

## Look

| Key                 | What it does                                   |
| ------------------- | ---------------------------------------------- |
| `<Space>uB`         | Transparent background off / on                |
| `<Space>ut`         | Sticky function/class header off / on          |
| `<Space>uw`         | Line wrap off / on                             |
| `<Space>uz`         | Zen mode                                       |

## Big files

Files over 1.5 MB open in a light mode without language server, syntax tree or folds,
so they stay fast. `<Space>cj` still formats JSON there.
