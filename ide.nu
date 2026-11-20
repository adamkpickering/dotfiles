# A cross-platform way to configure my development setup.

let linux_paths = {
	gitconfig: ('~/.config/git/config' | path expand)
	wezterm: ('~/.wezterm.lua' | path expand)
	nushell: ('~/.config/nushell' | path expand)
	helix: ('~/.config/helix' | path expand)
	pi: ('~/.pi/agent' | path expand)
}

let windows_paths = {
	gitconfig: ('~/.gitconfig' | path expand)
	wezterm: ('~/.wezterm.lua' | path expand)
	nushell: ('~/AppData/Roaming/nushell' | path expand)
	helix: ('~/AppData/Roaming/helix' | path expand)
	pi: ('~/.pi/agent' | path expand)
}

let darwin_paths = {
	gitconfig: ('~/.gitconfig' | path expand)
	wezterm: ('~/.wezterm.lua' | path expand)
	nushell: ('~/Library/Application Support/nushell' | path expand)
	helix: ('~/.config/helix' | path expand)
	pi: ('~/.pi/agent' | path expand)
}

def host_name [] {
	sys host | get name
}

def pick_paths [] {
	let name = (host_name)
	if $name == 'Windows' {
		$windows_paths
	} else if $name == 'Darwin' {
		$darwin_paths
	} else {
		$linux_paths
	}
}

# Every file or directory that the installer puts on the filesystem.
# src and dest are repo-relative and absolute respectively; kind is 'file'
# or 'dir'; check = false marks entries that are generated or user-owned.
def mappings [paths: record] {
	[
		{
			name: 'git'
			src: 'git/.gitconfig'
			dest: $paths.gitconfig
			kind: 'file'
			check: true
		}
		{
			name: 'wezterm'
			src: 'wezterm/.wezterm.lua'
			dest: $paths.wezterm
			kind: 'file'
			check: true
		}
		{
			name: 'nushell'
			src: 'nushell/config.nu'
			dest: ([$paths.nushell, 'config.nu'] | path join)
			kind: 'file'
			check: true
		}
		{
			name: 'nushell secrets'
			src: 'nushell/secrets.nu'
			dest: ([$paths.nushell, 'secrets.nu'] | path join)
			kind: 'file'
			check: false
		}
		{
			name: 'helix'
			src: 'helix/config.toml'
			dest: ([$paths.helix, 'config.toml'] | path join)
			kind: 'file'
			check: true
		}
		{
			name: 'helix languages'
			src: 'helix/languages.toml'
			dest: ([$paths.helix, 'languages.toml'] | path join)
			kind: 'file'
			check: true
		}
		{
			name: 'helix themes'
			src: 'helix/themes'
			dest: ([$paths.helix, 'themes'] | path join)
			kind: 'dir'
			check: true
		}
		{
			name: 'pi'
			src: 'pi/settings.json'
			dest: ([$paths.pi, 'settings.json'] | path join)
			kind: 'file'
			check: true
		}
		{
			name: 'pi instructions'
			src: 'pi/AGENTS.md'
			dest: ([$paths.pi, 'AGENTS.md'] | path join)
			kind: 'file'
			check: true
		}
	]
}

# Absolute paths of every file under root.
def files_under [root: path] {
	if not ($root | path exists) {
		return []
	}
	mut files = []
	for entry in (ls --all $root) {
		if $entry.type == 'dir' {
			$files = ($files | append (files_under $entry.name))
		} else if $entry.type in ['file' 'symlink'] {
			$files = ($files | append $entry.name)
		}
	}
	$files
}

def relative_files [root: path] {
	files_under $root
	| each {|file| $file | path relative-to $root | into string}
	| sort
}

def dir_same [src: path, dest: path] {
	let a = (relative_files $src)
	let b = (relative_files $dest)
	if $a != $b {
		return false
	}
	not ($a | any {|rel|
		(open --raw ([$src, $rel] | path join)) != (open --raw ([$dest, $rel] | path join))
	})
}

def state_of [mapping: record] {
	if not ($mapping.dest | path exists) {
		return 'missing'
	}
	let same = if $mapping.kind == 'dir' {
		dir_same $mapping.src $mapping.dest
	} else {
		(open --raw $mapping.src) == (open --raw $mapping.dest)
	}
	if $same { 'same' } else { 'differs' }
}

def main [] {
	print 'usage:'
	print '  nu ide.nu enforce <full_name> <email>'
	print '  nu ide.nu check'
}

# Copy everything from this repository to the filesystem.
def 'main enforce' [full_name: string, email: string] {
	let paths = (pick_paths)
	let plan = (mappings $paths)

	# install everything
	for mapping in $plan {
		print -n $"Configuring ($mapping.name)... "
		mkdir ($mapping.dest | path dirname)
		if $mapping.kind == 'dir' {
			# copying a directory into its parent keeps the repo directory name
			cp -r $mapping.src ($mapping.dest | path dirname)
		} else if $mapping.name == 'nushell secrets' {
			cp --no-clobber $mapping.src $mapping.dest
			if (host_name) != 'Windows' {
				chmod 600 $mapping.dest
			}
		} else {
			cp $mapping.src $mapping.dest
		}
		print 'done'
	}

	print -n 'Configuring git user... '
	git config --global --add user.name $full_name
	git config --global --add user.email $email
	print 'done'
}

# Print a colored diff of one mapping.
# complete is used because a diff with changes exits with 1, which would
# otherwise stop the rest of the script.
def show_diff [mapping: record] {
	let result = if $mapping.kind == 'dir' {
		^diff -r -u --color=always $mapping.src $mapping.dest | complete
	} else {
		^diff -u --color=always --label $"repo: ($mapping.src)" --label $"disk: ($mapping.dest)" $mapping.src $mapping.dest | complete
	}
	print -n $result.stdout
	if not ($result.stderr | is-empty) {
		print $result.stderr
	}
}

# Print a colored diff for every file that differs; print nothing otherwise.
def 'main check' [] {
	let paths = (pick_paths)
	for mapping in (mappings $paths | where check) {
		let state = (state_of $mapping)
		if $state != 'same' {
			print $'=== ($mapping.name)'
			if $state == 'missing' {
				print $'disk path missing: ($mapping.dest)'
			} else {
				show_diff $mapping
			}
			print ''
		}
	}
}
