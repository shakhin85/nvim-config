# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration using Lazy.nvim as the plugin manager. The configuration follows a modular structure with clear separation of concerns:

- **Entry Point**: `init.lua` loads core modules and sets up Python provider detection using UV
- **Core Configuration**: Located in `lua/shakhin/core/`
  - `options.lua`: Editor options and settings
  - `keymaps.lua`: Key bindings and shortcuts
- **Plugin Management**: `lua/shakhin/lazy.lua` configures Lazy.nvim and imports plugin modules
- **Plugin Configurations**: `lua/shakhin/plugins/` contains individual plugin setups
- **LSP Setup**: `lua/shakhin/plugins/lsp/` contains Language Server Protocol configurations

## Key Components

### Plugin Management
- Uses Lazy.nvim with automatic plugin checking enabled
- Plugins are organized in separate files under `lua/shakhin/plugins/`
- LSP-related plugins are in a dedicated `lsp/` subfolder
- Lock file: `lazy-lock.json` tracks exact plugin versions

### LSP Configuration
The LSP setup uses Mason for tool management:
- **mason.lua**: Installs and manages LSP servers, formatters, and linters
- **lspconfig.lua**: Configures individual language servers
- Supports Python, TypeScript/JavaScript, HTML, CSS, Tailwind, Svelte, Lua, GraphQL, Rust, and more

### Key Bindings
- Leader key: Space (`<leader>`)
- Exit insert mode: `jk`
- Window management: `<leader>s*` prefix
- Tab management: `<leader>t*` prefix
- Buffer navigation: Tab/Shift+Tab for cycling
- Debug shortcuts: F5 (start), F9 (breakpoint), F3/F4 (step)

### Python Development
- Dynamic Python provider detection using UV package manager
- Configured LSP: Pyright
- Tools: Black (formatter), isort (import sorting), ruff (linter), debugpy (debugger)
- Custom command: `:MasonInstallPython` to install Python tools

## Common Commands

### Plugin Management
```vim
:Lazy                    " Open Lazy plugin manager
:Lazy update            " Update all plugins
:Lazy clean             " Remove unused plugins
```

### LSP and Tools Management
```vim
:Mason                  " Open Mason tool installer
:MasonInstallPython     " Install Python development tools
:MasonUpdateAll         " Update all Mason packages
```

### Development Workflow
1. Use Mason to install language servers and tools for your languages
2. LSP features (go-to-definition, hover, etc.) work automatically once servers are installed
3. Formatting is handled by conform.nvim with language-specific formatters
4. Use the integrated terminal and debugging features for development

### File Navigation
- Use harpoon for quick file switching
- Flash.nvim provides enhanced navigation within files
- Auto-session manages workspace sessions

## Notable Features
- Catppuccin color scheme with termguicolors support
- Bufferline for tab-like buffer management
- Git integration with gitsigns
- Auto-completion with nvim-cmp
- Snippet support with LuaSnip
- Alpha dashboard for startup screen
- Automatic session management