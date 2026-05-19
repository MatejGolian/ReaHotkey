#Requires AutoHotkey v2.0

AboutText := "
(
Press Shift+Windows+D to adtivate or deactivate the overlay editor.
Use standard commands to move through the overlay when the editor is active.
Press the Applications key to open the editor context menu when a control has focus.
Note that most project-related commands do not work when the editor feature is inactive. On the other hand, functions aimed at a more general purpose, such as those found in the script's Tools menu, remain accessible regardless of editor state.

Keyboard Shortcuts

Always active:
Shift+Windows+D - Toggle editor active/inactive
Shift+Windows+F1 - Open this window
Shift+Windows+P - Toggle pause
Shift+Windows+Q - Quit
Shift+Windows+Insert - Add marker at mouse cursor
Shift+Windows+Del - Delete all markers
Shift+Windows+F - Focus control
Shift+Windows+U - Route the mouse to the currently focused control
Shift+Windows+Print screen - Extract a portion of the active window to an image
Shift+Windows+I - Search for an image on the screen
Shift+Windows+R - Repeat search for last image
Shift+Windows+O - Perform OCR
Shift+Windows+G - Generate markers from OCR
Shift+Windows+W - View info about the active window
Shift+Windows+C - View info about the currently focused control
Shift+Windows+L - View control list
Shift+Windows+M - View mouse related info
Shift+Windows+V - View clipboard contents
Shift+Windows+B - Report pixel color under the mouse
Shift+Windows+Left - Move mouse left
Shift+Windows+Right - Move mouse right
Shift+Windows+Up - Move mouse up
Shift+Windows+Down - Move mouse down
Shift+Windows+X - Set mouse X position
Shift+Windows+Y - Set mouse Y position
Shift+Windows+Z - Report mouse position

When The Editor Is Active:
Applications - Open editor context menu
Ctrl+N - Create a new project
Ctrl+O - Open an existing project
Ctrl+S - Save project
Ctrl+Alt+S - Save project as
Shift+Windows+E - Generate AutoHotkey code for external use
Ctrl+Z - Undo
Ctrl+X - Cut
Ctrl+C - Copy
Ctrl+V - Paste
Del - Delete item
F2 - Item properties
Shift+Windows+N - Nudge/Re-calculate item coordinates
Shift+Windows+H - Add HotspotButton at mouse cursor
Shift+Windows+S - Set Hotspot coordinates to current mouse position

)"
