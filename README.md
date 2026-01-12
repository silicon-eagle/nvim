# kickstart.nvim

## Introduction

This is no longer the vanilla Kickstart sample. It is a curated daily-driver
configuration focused on fast navigation, Python-first workflows, and a clean
UI that stays out of the way. Kickstart's structure is still here, but every
layer has been expanded with opinionated plugins, theme modules, and helper
utilities to cover day-to-day development on Windows, macOS, and Linux.

### Highlights
- `Blink.cmp` + `LuaSnip` power autocompletion with type-aware snippets and Lua
  LSP docs from `lazydev`.
- `nvim-lspconfig` + `mason` + `basedpyright` + `ruff` handle language servers,
  formatters, and diagnostics while `none-ls` wires up format-on-save.
- Snacks.nvim provides modern UX niceties (status column, smooth scrolling,
  slick notifications, picker, indent guides) without extra config.
- UI polish via `bufferline`, `lualine`, `neo-tree`, `aerial`, `indent-blankline`,
  and `noice` keeps buffers, symbols, and messages tidy.
- Batteries for testing (`custom.utils.pytest`, pytest keymaps, dap-python) and
  debugging (`nvim-dap`, `dap-ui`, custom signs) are ready out of the box.
- CopilotChat is built in for inline AI chat with command palette triggers.

### Plugin Stack at a Glance
| Category | Plugins / Notes |
| --- | --- |
| Completion & Snippets | `saghen/blink.cmp`, `LuaSnip`, `folke/lazydev.nvim` |
| LSP & Diagnostics | `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig`, `mason-tool-installer`, `nvimtools/none-ls.nvim`, `j-hui/fidget.nvim` |
| Treesitter & Text Objects | `nvim-treesitter`, `mini.ai`, `mini.surround`, `todo-comments.nvim` |
| Navigation & Search | `telescope.nvim` (+ `telescope-fzf-native`, `telescope-ui-select`), `ThePrimeagen/harpoon` (v2), `stevearc/aerial.nvim` |
| UI & Workflow | `bufferline.nvim`, `lualine.nvim`, `nvim-neo-tree`, `folke/noice.nvim`, `folke/snacks.nvim`, `indent-blankline.nvim`, `windwp/nvim-autopairs`, `which-key.nvim` |
| Git | `lewis6991/gitsigns.nvim`, `kdheepak/lazygit.nvim` |
| Testing & Debugging | `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, `mason-nvim-dap`, `nvim-dap-python`, custom pytest helpers in `lua/custom/utils/pytest.lua` |
| AI Assist | `CopilotC-Nvim/CopilotChat.nvim` with floating chat buffers |

### Key Customizations
- Leader key is `<Space>` with `which-key` categories for buffers, git, debug,
  pytest, and more. Buffer/tab controls come from `bufferline` plus Harpoon v2
  mappings (`<leader>hh`, `<leader>hm`, `<leader>1..9`).
- Themes live in `lua/custom/themes/*`. Set `$NVIM_THEME` to `onedark`,
  `tokyonight`, or `rosepine` (default: onedark) before launching Neovim to
  swap palettes without touching Lua.
- `lua/custom/utils/root.lua` and `config.icons` drive the lualine components,
  showing the project root and pretty buffer paths next to diagnostics and git
  stats.
- Python quality-of-life: automatic interpreter detection via `uv python find`
  fallback (`custom.utils.python`), pytest orchestration with Snacks terminals
  (`<leader>pm/pf/pl`), and dap-python pre-wired for pytest debugging.
- Snacks.nvim handles scroll, indent scope, statuscolumn, notifications, and a
  fuzzy picker—`<leader>ns` opens recent notifications, `<leader>nd` dismisses
  them.
- Format-on-save is enabled through `none-ls` for Lua (stylua), Ruff (formatting
  + import order), Prettier, shfmt, and Terraform.
- CopilotChat shortcuts: `<leader>aa` toggles the chat window, `<leader>aq`
  prompts for a quick question, `<leader>ap` opens prompt presets.

### Project Layout
- `lua/config/` — options, keymaps, autocmds, and custom icon definitions loaded
  before Lazy.
- `lua/custom/plugins/` — one plugin per file for clarity (LSP, Treesitter,
  Telescope, Harpoon, DAP, etc.). Add new specs here to keep upstream merges
  painless.
- `lua/custom/themes/` — theme modules selected dynamically via `$NVIM_THEME`.
- `lua/custom/utils/` — utility modules for pytest runners, python resolution,
  and root/path helpers used by statusline + commands.
- `lua/custom/health.lua` — `:checkhealth kickstart.nvim` entries validating
  dependencies like git/make/rg.

This README now reflects the current setup; see individual plugin files for the
exact Lazy specs or run `:Lazy` inside Neovim for live status.

## Installation

## Installation basics
If you want to keep backup: make a backup :)

Else, run this for a clean install:

```bash
# Delete
Remove-Item $env:LOCALAPPDATA\nvim -Recurse -Force
Remove-Item $env:LOCALAPPDATA\nvim-data -Recurse -Force

# Clone starter
git clone https://github.com/silicon-eagle/nvim.git "${env:LOCALAPPDATA}\nvim"
```


### Install Neovim

Kickstart.nvim targets *only* the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest
['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) of Neovim.
If you are experiencing issues, please make sure you have the latest versions.

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation),
  [fd-find](https://github.com/sharkdp/fd#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Emoji fonts (Ubuntu only, and only if you want emoji!) `sudo apt install fonts-noto-color-emoji`
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

#### Install Details
Install [choco](https://chocolatey.org/install) 
```
# git
choco install git layzgit

# neovim
choco install neovim --pre

# neovim utils
choco install make unzip ripgrep mingw fd

# python
choco install uv python
```
Install [MSVC](https://rust-lang.github.io/rustup/installation/windows-msvc.html)
Install rust with [rustup](https://rust-lang.github.io/rustup/installation/windows-msvc.html)


> [!NOTE]
> See [Install Recipes](#Install-Recipes) for additional Windows and Linux specific notes
> and quick install snippets

### Install Kickstart

> [!NOTE]
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> [!NOTE]
> Your fork's URL will be something like this:
> `https://github.com/<your_github_username>/kickstart.nvim.git`

You likely want to remove `lazy-lock.json` from your fork's `.gitignore` file
too - it's ignored in the kickstart repo to make maintenance easier, but it's
[recommended to track it in version control](https://lazy.folke.io/usage/lockfile).

#### Clone kickstart.nvim

> [!NOTE]
> If following the recommended step above (i.e., forking the repo), replace
> `nvim-lua` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/silicon-eagle/nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/silicon-eagle/nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

#### Read The Friendly Documentation

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.

> [!NOTE]
> For more information about a particular plugin check its repository's documentation.


### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

### FAQ

* What should I do if I already have a pre-existing Neovim configuration?
  * You should back it up and then delete all associated files.
  * This includes your existing init.lua and the Neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
* Can I keep my existing configuration in parallel to kickstart?
  * Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the kickstart
    configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim
    distribution that you would like to try out.
* What if I want to "uninstall" this configuration:
  * See [lazy.nvim uninstall](https://lazy.folke.io/usage#-uninstalling) information
* Why is the kickstart `init.lua` a single file? Wouldn't it make sense to split it into multiple files?
  * The main purpose of kickstart is to serve as a teaching tool and a reference
    configuration that someone can easily use to `git clone` as a basis for their own.
    As you progress in learning Neovim and Lua, you might consider splitting `init.lua`
    into smaller parts. A fork of kickstart that does this while maintaining the
    same functionality is available here:
    * [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  * Discussions on this topic can be found here:
    * [Restructure the configuration](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    * [Reorganize init.lua into a multi-file setup](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#Install-Kickstart) step.

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>
Installation may require installing build tools and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
</details>
<details><summary>Windows with gcc/make using chocolatey</summary>
Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit the previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```
</details>

