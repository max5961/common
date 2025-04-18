# Keymaps

---

- `Font Size Adjustments`
    - Decrease:
        - [Ctrl + w, Ctrl + -]
    - Increase:
        - [Ctrl + w, Ctrl + =]

- `Show Key Mappings`
    - Show All Mappings
        - [:map]
    - Show Normal Mappings
        - [:nmap]
    - Show Visual Mappings
        - [:vmap]
    - Show Insert Mappings
        - [:imap]
    - Show Command Mode Mappings
        - [:cmap]

- `Window Sizing`
    - Increase Split Height
        - [Ctrl + Up]
    - Decrease Split Height
        - [Ctrl + Down]
    - Increase Split Width
        - [Ctrl + Right]
    - Decrease Split Width
        - [Ctrl + Left]
    - Toggle Full Screen
        - [Leader + fs]

- `Editing`
    - Add Repeatable Character(s) in Visual Block
        - [Ctrl + v, I, <character(s)>, Esc]
    - Increment Number
        - [Ctrl + a]
    - Increment Numbers in Visual Block
        - [Ctrl + v, g, Ctrl + a]

- `Split Window`
    - Split current window vertically
        - [Ctrl + w + v]
    - Split current window horizontally
        - [Ctrl + w + s]

- `Tools`
    - Show Completion Path/To/File
        - [Ctrl + x, Ctrl + f]
    - Show LSP Definitions for Word Under Cursor
        - [K]

- `Format`
    - Visual select all lines to format [gq] to format

`Tmux Integration`
    - Start Tracking Vim Session
        [:Obsession]
    - Stop Tracking Vim Session (and delete the Session.vim file)
        - [:Obsession!]
    - Save Tmux Environment
        - [prefix + C-s]
    - Restore Tmux Environment
        - [prefix + C-r]

**Note on tmux-resurrect & tpope/obsession**
- obsession creates a Session.vim file to track changes
- obsession automatically saves sessions on buffer changes
- resurrect allows persistence of tmux sessions between reboots
- resurrect requires manual saving/reloading of sessions









