# A cross-platform way to configure my development setup.

let linux_paths = {
	gitconfig: ('~/.gitconfig' | path expand)
	wezterm: ('~/.wezterm.lua' | path expand)
	nushell: ('~/.config/nushell' | path expand)
	helix: ('~/.config/helix' | path expand)
}

let windows_paths = {
	gitconfig: ('~/.gitconfig' | path expand)
	wezterm: ('~/.wezterm.lua' | path expand)
	nushell: ('~/AppData/Roaming/nushell' | path expand)
	helix: ('~/AppData/Roaming/helix' | path expand)
}

def main [full_name: string, email: string] {
	# determine which set of paths to use
	let paths = if (sys host | get name) == 'Windows' {
		$windows_paths
	} else {
		$linux_paths
	}

	# install everything
	print -n "Configuring git... "
	open git/.gitconfig |
		str replace 'vim' 'hx' |
		lines |
		append $"[user]\n  name = ($full_name)\n  email = ($email)" |
		str join "\n" |
		save -f $paths.gitconfig
	print "done"

	print -n "Configuring wezterm... "
	cp wezterm/.wezterm.lua $paths.wezterm
	print "done"

	print -n "Configuring nushell... "
	mkdir $paths.nushell
	cp nushell/config.nu ([$paths.nushell, 'config.nu'] | path join)
	print "done"

	print -n "Configuring helix... "
	mkdir ([$paths.helix, 'themes'] | path join)
	cp helix/config.toml ([$paths.helix, 'config.toml'] | path join)
	cp -r helix/themes ([$paths.helix] | path join)
	print "done"
}
