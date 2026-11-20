-- Rex config, migrated from tmux, Ghostty and iTerm2.

-- tmux (~/.tmux.conf), prefix ctrl+a
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>a", "pane.send_key", { key = "ctrl+a" })
rex.bind("ctrl+a>up", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>down", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>left", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>right", "pane.focus", { direction = "right" })
rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })

-- iTerm2 GlobalKeyMap
rex.bind("shift+cmd+left", "client.tab.move", { direction = "backward" })
rex.bind("shift+cmd+right", "client.tab.move", { direction = "forward" })

-- iTerm2 profile Keyboard Map (Default and Hot Key): hex codes of one key
rex.bind("ctrl+2", "pane.send_key", { key = "ctrl+shift+2" })
rex.bind("ctrl+3", "pane.send_key", { key = "esc" })
rex.bind("ctrl+4", "pane.send_key", { key = "ctrl+\\" })
rex.bind("ctrl+5", "pane.send_key", { key = "ctrl+]" })
rex.bind("ctrl+6", "pane.send_key", { key = "ctrl+shift+6" })
rex.bind("ctrl+7", "pane.send_key", { key = "ctrl+shift+-" })
rex.bind("ctrl+8", "pane.send_key", { key = "backspace" })
rex.bind("ctrl+-", "pane.send_key", { key = "ctrl+shift+-" })
