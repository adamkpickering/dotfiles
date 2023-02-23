function fish_prompt
    git rev-parse --is-inside-work-tree &> /dev/null
    if test $status -eq 0
        printf '\n'
        git status --short --branch
        printf '%s> ' (pwd)
    else
        printf '%s> ' (pwd)
    end
end
# def create_left_prompt [] {
#     let result = ( do -i { git rev-parse --is-inside-work-tree | complete } )
#     if $result.exit_code == 0 {
#         print -n "\n"
#         print -n (git status --short --branch)
#         let repo_dir =  (git rev-parse --show-toplevel | path basename | str trim)
#         let repo_path = (git rev-parse --show-prefix | path split | drop 1 | prepend $repo_dir | path join)
#         echo [(ansi reset) (ansi yellow) $repo_path (ansi reset)] | str collect
#     } else {
#         echo [(ansi reset) (ansi yellow) $env.PWD (ansi reset)] | str collect
#     }
# }
