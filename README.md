Installation
------------

First, install [ansible][1].

Then, execute

    ansible-pull -U https://github.com/adamkpickering/dotfiles.git -i hosts -e "username=adam" setup.yml

Where [your username] is the name of your local user account (i.e. if my home directory is /home/adam my username is "adam"). Ansible will do the rest for you.

[1]: http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
