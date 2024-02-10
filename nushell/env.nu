# Nushell Environment Config File
#
# version = "0.87.0"

def create_left_prompt [] {
    let result = ( do -i { git rev-parse --is-inside-work-tree | complete } )
    if $result.exit_code == 0 {
        let first_part = $"\n(git status --short --branch)\n"
        let repo_full_path = (git rev-parse --show-toplevel)
        let repo_name =  ($repo_full_path | path basename)
        let relative_repo_path = ($env.PWD | path relative-to $repo_full_path)
        let repo_path = ([$repo_name $relative_repo_path] | path join)
        [$first_part (ansi reset) (ansi yellow) $repo_path (ansi reset)] | str join
    } else {
        [(ansi reset) (ansi yellow) $env.PWD (ansi reset)] | str join
    }
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
if (sys | get host.name) != 'Windows' {
    $env.PATH = ($env.PATH | split row (char esep) | prepend '~/.rd/bin')
    $env.PATH = ($env.PATH | split row (char esep) | append '~/.local/bin')
    $env.PATH = ($env.PATH | split row (char esep) | append '/usr/local/go/bin')
    $env.GOPATH = '/home/adam/.go'
    $env.GOBIN = '/home/adam/.local/bin'
}

# Added by me
$env.EDITOR = 'hx'
