# A cross-platform way to configure my development setup.

# USAGE=$(cat << EOF
# Usage: ./base.sh <full_name> <email> [OPTIONS]
# EOF
# )

# if [ -z "$1" ] || [ -z "$2" ]; then
# 	printf '%s\n' "$USAGE"
# 	exit 1
# else
# 	FULL_NAME="$1"
# 	EMAIL="$2"
# fi


# printf 'Configuring git... '
# cp .gitconfig ~/.gitconfig
# cat << EOF >> ~/.gitconfig
# [user]
#   name = $FULL_NAME
#   email = $EMAIL
# EOF
# printf 'done\n'


# printf 'Configuring wezterm... '
# printf 'done\n'
def main [full_name: string, email: string] {
	print -n "Configuring git... "
	open .gitconfig | lines | append $"[user]\n  name = ($full_name)\n  email = ($email)" | str collect "\n" | save ~/.gitconfig
	print "done"

	print -n "Configuring wezterm... "
	cp .wezterm.lua ~/.wezterm.lua
	print "done"

	print -n "Configuring nushell... "
	print "done"

	print -n "Configuring helix... "
	print "done"

}
