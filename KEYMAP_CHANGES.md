# Keymap Conflict Resolution

This document describes all keymap conflicts that were identified and resolved.

## Summary of Changes

All keymaps are now registered in `which-key.lua` for easy discovery via `<leader>?` or waiting after pressing `<leader>`.

---

## CRITICAL CONFLICTS RESOLVED

### 1. **`<leader>mr` - Format vs Molten Re-evaluate**

**Problem:** Both formatting (ruff) and Molten (Jupyter) used `<leader>mr`

**Solution:**
- **Formatting** (ruff): Kept as `<leader>mr` (more commonly used)
- **Molten**: Changed to `<leader>mR` (uppercase R for Re-evaluate)

**Files changed:**
- `lua/shakhin/plugins/molten.lua:48`
- `lua/shakhin/plugins/which-key.lua:168`

---

### 2. **`]c` / `[c` - Git Hunks vs Molten Cells**

**Problem:** Both gitsigns (git hunks) and Molten (notebook cells) used `]c` and `[c`

**Solution:**
- **Gitsigns**: Kept as `]c` / `[c` (more commonly used)
- **Molten**: Changed to `]m` / `[m` (m for Molten)

**Files changed:**
- `lua/shakhin/plugins/molten.lua:51-52`
- `lua/shakhin/plugins/which-key.lua:240,246`

**Rationale:** Git hunks are used more frequently than Molten cell navigation. Using `]m` / `[m` is intuitive (m = Molten/cell).

---

### 3. **`<leader>l` - Single Key vs LSP Group**

**Problem:** Linting trigger (`<leader>l`) conflicted with LSP group prefix (`<leader>l*`)

**Solution:**
- **LSP group**: Kept as `<leader>l` prefix
- **Linting**: Changed to `<leader>ll` (double l for "lint")

**Files changed:**
- `lua/shakhin/plugins/linting.lua:71`
- `lua/shakhin/plugins/which-key.lua:138`

**Rationale:** Group prefixes should never be bound to direct actions. `<leader>ll` is easy to remember (lint = ll).

---

### 4. **`<leader>tf` - Terminal Float vs Tab Open**

**Problem:** Both toggleterm (floating terminal) and tab management used `<leader>tf`

**Solution:**
- **Tab management**: Kept as `<leader>tF` (uppercase F, already changed in keymaps.lua)
- **Terminal float**: Changed to `<leader>t.` (dot for floating/popup)

**Files changed:**
- `lua/shakhin/plugins/toggleterm.lua:78`
- `lua/shakhin/plugins/which-key.lua:47`

**Rationale:** Lowercase `t` is for terminal operations, uppercase `T` or special chars for tab/window operations. Using `.` is intuitive for "floating" popup.

---

## DUPLICATE KEYMAPS REMOVED

### 5. **Telekasten Duplicates**

**Removed:**
- `<leader>z#` (duplicate of `<leader>zt` - show tags)
- `<leader>zw` (duplicate of `<leader>zT` - go to this week)

**Files changed:**
- `lua/shakhin/plugins/telekasten.lua:78,80`

---

## NEW WHICH-KEY REGISTRATIONS

### Added Groups:

1. **`<leader>m` - Format/Molten**
   - Now includes both formatting tools AND Molten (Jupyter) commands
   - All Molten keymaps now visible in which-key

2. **`<leader>z` - Telekasten/Notes**
   - Complete Telekasten note-taking workflow
   - All 16+ keymaps now registered

3. **`<leader>l` - LSP**
   - Added `<leader>ll` for manual linting trigger
   - All LSP operations clearly documented

---

## COMPLETE KEYMAP REFERENCE

### Navigation (Non-Leader)

| Key | Action | Plugin |
|-----|--------|--------|
| `]c` | Next git hunk | gitsigns |
| `[c` | Previous git hunk | gitsigns |
| `]d` | Next diagnostic | LSP |
| `[d` | Previous diagnostic | LSP |
| `]m` | Next Molten cell | molten |
| `[m` | Previous Molten cell | molten |
| `]t` | Next todo | todo-comments |
| `[t` | Previous todo | todo-comments |

### LSP Group (`<leader>l`)

| Key | Action |
|-----|--------|
| `<leader>ll` | Trigger linting (manual) |
| `<leader>lf` | Format Python file |
| `<leader>lr` | Rename symbol |
| `<leader>la` | Code action |
| `<leader>ls` | Restart LSP |
| `<leader>ld` | Line diagnostics |
| `<leader>lD` | Buffer diagnostics |
| `<leader>lo` | Organize imports |

### Format/Molten Group (`<leader>m`)

**Formatting:**
| Key | Action |
|-----|--------|
| `<leader>mp` | Format (default) |
| `<leader>ma` | Format (autopep8) |
| `<leader>mr` | Format (ruff) |
| `<leader>mt` | Trim trailing whitespace |
| `<leader>mT` | Trim trailing blank lines |

**Molten (Jupyter):**
| Key | Action |
|-----|--------|
| `<leader>mi` | Initialize kernel |
| `<leader>me` | Evaluate line/visual |
| `<leader>mR` | Re-evaluate cell |
| `<leader>mo` | Show output |
| `<leader>mh` | Hide output |
| `<leader>md` | Delete cell |
| `<leader>mx` | Interrupt kernel |
| `<leader>mk` | Kernel info |
| `<leader>ms` | Save session |
| `<leader>ml` | Load session |
| `<leader>mI` | Init Python3 kernel |

### Terminal Group (`<leader>t`)

**Tab Management:**
| Key | Action |
|-----|--------|
| `<leader>to` | Open new tab |
| `<leader>tx` | Close tab |
| `<leader>tn` | Next tab |
| `<leader>tP` | Previous tab |
| `<leader>tF` | Open buffer in new tab |

**Terminal:**
| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle terminal |
| `<leader>t.` | Floating terminal |
| `<leader>th` | Horizontal terminal |
| `<leader>tv` | Vertical terminal |
| `<leader>t1-3` | Terminal 1-3 |
| `<leader>tcc` | Clear terminal |

**Python:**
| Key | Action |
|-----|--------|
| `<leader>tp` | Run Python file |
| `<leader>ti` | Run in IPython |
| `<leader>tI` | Clean IPython |
| `<leader>tR` | Python REPL |

### Telekasten/Notes (`<leader>z`)

| Key | Action |
|-----|--------|
| `<leader>zf` | Find notes |
| `<leader>zg` | Search in notes |
| `<leader>zd` | Today's note |
| `<leader>zz` | Follow link |
| `<leader>zn` | New note |
| `<leader>zc` | Show calendar |
| `<leader>zb` | Show backlinks |
| `<leader>zI` | Insert image link |
| `<leader>zt` | Show tags |
| `<leader>zT` | Go to this week |
| `<leader>zW` | Find weekly notes |
| `<leader>zl` | Insert link |
| `<leader>zp` | Command panel |
| `<leader>zr` | Rename note |
| `<leader>zm` | Preview image |
| `<leader>zi` | Paste image |
| `<leader>z[` | Toggle todo |

---

## How to Use Which-Key

1. **View all keymaps**: Press `<leader>?` in normal mode
2. **Explore a group**: Press `<leader>` and wait 300ms - which-key will show all available subkeys
3. **Example**:
   - Press `<leader>m` → See all Format/Molten commands
   - Press `<leader>l` → See all LSP commands
   - Press `<leader>z` → See all Note-taking commands

---

## Testing

After restarting Neovim, verify:

```vim
:checkhealth which-key
:WhichKey <leader>
```

All keymaps should now be conflict-free and discoverable!

---

**Last updated:** 2025-11-04
**Files modified:** 4 plugin files + which-key.lua
