# Programs
Things to install
    - nvim 
    - eza
    - zoxide
    - duff
    - btop
    - bat

# Key bindings
- Rember to swap esc with caps lock
- cmd + ` for iterm2/fire fox swap. Automator script below
```
tell application "System Events"
    set frontApp to name of first application process whose frontmost is true
end tell

if frontApp is "Firefox" then
    tell application "iTerm2" to activate
else if frontApp is "iTerm" or frontApp is "iTerm2" then

```

