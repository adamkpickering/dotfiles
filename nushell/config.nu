# --------------------------------------------------------------------------------
# Add completions
# --------------------------------------------------------------------------------

module completions {
  # Custom completions for external commands (those outside of Nushell)
  # Each completions has two parts: the form of the external command, including its flags and parameters
  # and a helper command that knows how to complete values for those flags and parameters
  #
  # This is a simplified version of completions for git branches and git remotes
  def "nu-complete git all_branches" [] {
    let all_branches = (^git branch --all | lines | each {
      |line| $line | str replace '[\*\+] ' '' | str trim
    })
    let remote_branches = ($all_branches | str replace 'remotes/' '')
    let no_remote_remote_branches = ($all_branches | find -r '^remotes/' | find -v HEAD | path split | each { |split_path| $split_path | range 2.. | path join })
    $remote_branches | append $no_remote_remote_branches | uniq
  }

  def "nu-complete git local_branches" [] {
    ^git branch | lines | each { |line| $line | str replace '[\*\+] ' '' | str trim }
  }

  def "nu-complete git remotes" [] {
    ^git remote | lines | each { |line| $line | str trim }
  }

  export extern "git c" [
    branch?: string@"nu-complete git all_branches" # name of the branch to checkout
  ]

  export extern "git bd" [
    branch?: string@"nu-complete git local_branches"
  ]

  export extern "git merge" [
    branch?: string@"nu-complete git all_branches"
    --help
  ]

  export extern "git rebase" [
    --interactive(-i)
    ref?: string@"nu-complete git all_branches"
    --onto: string@"nu-complete git all_branches"
    --abort
    --continue
    --skip
    --help
  ]

  export extern "git reset" [
    --soft
    --mixed
    --hard
    ref?: string@"nu-complete git all_branches"
    --help
  ]

  # Download objects and refs from another repository
  export extern "git fetch" [
    repository?: string@"nu-complete git remotes" # name of the repository to fetch
    branch?: string@"nu-complete git all_branches" # name of the branch to fetch
    --all                                         # Fetch all remotes
    --append(-a)                                  # Append ref names and object names to .git/FETCH_HEAD
    --atomic                                      # Use an atomic transaction to update local refs.
    --depth: int                                  # Limit fetching to n commits from the tip
    --deepen: int                                 # Limit fetching to n commits from the current shallow boundary
    --shallow-since: string                       # Deepen or shorten the history by date
    --shallow-exclude: string                     # Deepen or shorten the history by branch/tag
    --unshallow                                   # Fetch all available history
    --update-shallow                              # Update .git/shallow to accept new refs
    --negotiation-tip: string                     # Specify which commit/glob to report while fetching
    --negotiate-only                              # Do not fetch, only print common ancestors
    --dry-run                                     # Show what would be done
    --write-fetch-head                            # Write fetched refs in FETCH_HEAD (default)
    --no-write-fetch-head                         # Do not write FETCH_HEAD
    --force(-f)                                   # Always update the local branch
    --keep(-k)                                    # Keep dowloaded pack
    --multiple                                    # Allow several arguments to be specified
    --auto-maintenance                            # Run 'git maintenance run --auto' at the end (default)
    --no-auto-maintenance                         # Don't run 'git maintenance' at the end
    --auto-gc                                     # Run 'git maintenance run --auto' at the end (default)
    --no-auto-gc                                  # Don't run 'git maintenance' at the end
    --write-commit-graph                          # Write a commit-graph after fetching
    --no-write-commit-graph                       # Don't write a commit-graph after fetching
    --prefetch                                    # Place all refs into the refs/prefetch/ namespace
    --prune(-p)                                   # Remove obsolete remote-tracking references
    --prune-tags(-P)                              # Remove any local tags that do not exist on the remote
    --no-tags(-n)                                 # Disable automatic tag following
    --refmap: string                              # Use this refspec to map the refs to remote-tracking branches
    --tags(-t)                                    # Fetch all tags
    --recurse-submodules: string                  # Fetch new commits of populated submodules (yes/on-demand/no)
    --jobs(-j): int                               # Number of parallel children
    --no-recurse-submodules                       # Disable recursive fetching of submodules
    --set-upstream                                # Add upstream (tracking) reference
    --submodule-prefix: string                    # Prepend to paths printed in informative messages
    --upload-pack: string                         # Non-default path for remote command
    --quiet(-q)                                   # Silence internally used git commands
    --verbose(-v)                                 # Be verbose
    --progress                                    # Report progress on stderr
    --server-option(-o): string                   # Pass options for the server to handle
    --show-forced-updates                         # Check if a branch is force-updated
    --no-show-forced-updates                      # Don't check if a branch is force-updated
    -4                                            # Use IPv4 addresses, ignore IPv6 addresses
    -6                                            # Use IPv6 addresses, ignore IPv4 addresses
    --help                                        # Display the help message for this command
  ]

  # Check out git branches and files
  export extern "git checkout" [
    ...targets: string@"nu-complete git all_branches"   # name of the branch or files to checkout
    --conflict: string                              # conflict style (merge or diff3)
    --detach(-d)                                    # detach HEAD at named commit
    --force(-f)                                     # force checkout (throw away local modifications)
    --guess                                         # second guess 'git checkout <no-such-branch>' (default)
    --ignore-other-worktrees                        # do not check if another worktree is holding the given ref
    --ignore-skip-worktree-bits                     # do not limit pathspecs to sparse entries only
    --merge(-m)                                     # perform a 3-way merge with the new branch
    --orphan: string                                # new unparented branch
    --ours(-2)                                      # checkout our version for unmerged files
    --overlay                                       # use overlay mode (default)
    --overwrite-ignore                              # update ignored files (default)
    --patch(-p)                                     # select hunks interactively
    --pathspec-from-file: string                    # read pathspec from file
    --progress                                      # force progress reporting
    --quiet(-q)                                     # suppress progress reporting
    --recurse-submodules: string                    # control recursive updating of submodules
    --theirs(-3)                                    # checkout their version for unmerged files
    --track(-t)                                     # set upstream info for new branch
    -b: string                                      # create and checkout a new branch
    -B: string                                      # create/reset and checkout a branch
    -l                                              # create reflog for new branch
    --help                                          # Display the help message for this command
  ]

  # Push changes
  export extern "git push" [
    remote?: string@"nu-complete git remotes",      # the name of the remote
    ...refs: string@"nu-complete git local_branches"      # the branch / refspec
    --all                                           # push all refs
    --atomic                                        # request atomic transaction on remote side
    --delete(-d)                                    # delete refs
    --dry-run(-n)                                   # dry run
    --exec: string                                  # receive pack program
    --follow-tags                                   # push missing but relevant tags
    --force-with-lease                              # require old value of ref to be at this value
    --force(-f)                                     # force updates
    --ipv4(-4)                                      # use IPv4 addresses only
    --ipv6(-6)                                      # use IPv6 addresses only
    --mirror                                        # mirror all refs
    --no-verify                                     # bypass pre-push hook
    --porcelain                                     # machine-readable output
    --progress                                      # force progress reporting
    --prune                                         # prune locally removed refs
    --push-option(-o): string                       # option to transmit
    --quiet(-q)                                     # be more quiet
    --receive-pack: string                          # receive pack program
    --recurse-submodules: string                    # control recursive pushing of submodules
    --repo: string                                  # repository
    --set-upstream(-u)                              # set upstream for git pull/status
    --signed: string                                # GPG sign the push
    --tags                                          # push tags (can't be used with --all or --mirror)
    --thin                                          # use thin pack
    --verbose(-v)                                   # be more verbose
    --help                                          # Display the help message for this command
  ]
}

use completions *

# --------------------------------------------------------------------------------
# Set environment variables
# --------------------------------------------------------------------------------

def create_left_prompt [] {
    if (git rev-parse --is-inside-work-tree | complete).exit_code == 0 {
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

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

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

if (sys host).name != 'Windows' {
    $env.PATH = ($env.PATH | split row (char esep) | prepend '~/.rd/bin')
    $env.PATH = ($env.PATH | split row (char esep) | append '~/.local/bin')
    $env.PATH = ($env.PATH | split row (char esep) | append '/usr/local/go/bin')
    $env.GOPATH = '/home/adam/.go'
    $env.GOBIN = '/home/adam/.local/bin'
}

$env.EDITOR = 'hx'

# --------------------------------------------------------------------------------
# Customize $env.config
# --------------------------------------------------------------------------------

$env.config.show_banner = false
$env.config.table.mode = "none"
$env.config.footer_mode = "auto"
$env.config.completions.quick = false
$env.config.history.sync_on_enter = false

# --------------------------------------------------------------------------------
# Custom commands for calling directly
# --------------------------------------------------------------------------------

def git-sync [] {
  let whitelisted_branches = [
    '^main$'
    '^master$'
    '^main-source$' # for rancher/partner-charts
    '^release/v[0-9]+\.[0-9]+$'
    '^release-v[0-9]+\.[0-9]+$'
  ]

  # Get a list of branches that has elements that look like:
  # {
  #   local: main,
  #   local_long: refs/heads/main,
  #   remote: origin/main,
  #   remote_long: refs/remotes/origin/main,
  # }
  # The branches are filtered down to ones where the local version
  # is a regex match for at least one whitelisted branch.
  let branches = (git for-each-ref --format='%(refname:short) %(refname) %(upstream:short) %(upstream)' refs/heads |
    lines |
    parse '{local} {local_long} {remote} {remote_long}' |
    filter {|branch|
      $whitelisted_branches | any {|whitelisted_branch| $branch.local =~ $whitelisted_branch}
    }
  )

  git fetch --all --prune
  for branch in $branches {
    if (git diff --quiet $branch.local $branch.remote | complete).exit_code == 0 {
      continue
    }
    git update-ref $branch.local_long $branch.remote_long
    print $"Updated branch ($branch.local) from ($branch.remote)"
  }
}

# k3dev manages a local installation of k3s for use as a development environment.
def "k3dev" [] {}

def "k3dev up" [] {
  let kubeconfig_dst_path = ("~/.kube/config" | path expand)
  let kubeconfig_src_path = "/etc/rancher/k3s/k3s.yaml"

  if (systemctl status k3s | complete).exit_code == 0 {
    error make {msg: "cluster already exists"}
  }

  if ($kubeconfig_dst_path | path exists) {
    error make {msg: $"($kubeconfig_dst_path) exists and kubeconfig merging is not implemented"}
  }

  curl -sfL https://get.k3s.io | sh -

  sudo cp $kubeconfig_src_path $kubeconfig_dst_path
  sudo chown $"(whoami):(whoami)" $kubeconfig_dst_path
}

def "k3dev down" [] {
  let kubeconfig_dst_path = ("~/.kube/config" | path expand)

  if (which k3s-uninstall.sh | length) != 1 {
    error make {msg: "no cluster to remove"}
  }

  rm -f $kubeconfig_dst_path

  k3s-uninstall.sh
}

def "nugit" [] {}

def "nugit branch" [] {}

def "nugit branch current" [] {
  git branch --show-current | collect | into string
}

def "nugit branch list" [] {
  git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads |
    parse '{name} {remote}'
}

def "nugit remote" [] {}

def "nugit remote list" [] {
  git remote -v |
    lines |
    where $it !~ '\(push\)$' |
    parse --regex '^(?P<name>\S+)\s+(?P<url>\S+) \(fetch\)$'
}
