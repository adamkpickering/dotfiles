# A cross-platform way to configure my development setup.

def main [full_name: string, email: string] {
	print -n "Configuring git... "
	open git/.gitconfig |
		str replace 'vim' 'hx' |
		lines |
		append $"[user]\n  name = ($full_name)\n  email = ($email)" |
		str collect "\n" |
		save ~/.gitconfig
	print "done"

	print -n "Configuring wezterm... "
	cp wezterm/.wezterm.lua ~/.wezterm.lua
	print "done"

	print -n "Configuring nushell... "
	mkdir ~/.config/nushell
	cp nushell/config.nu ~/.config/nushell/config.nu
	cp nushell/env.nu ~/.config/nushell/env.nu
	print "done"

	print -n "Configuring helix... "
	mkdir ~/.config/helix/themes
	cp helix/config.toml ~/.config/helix/config.toml
	cp -r helix/themes ~/.config/helix/themes
	print "done"
}
