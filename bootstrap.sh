#!/bin/bash

# Install pip
if ! command -v pip > /dev/null
then
  echo "installing pip"
  curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
  python3 /tmp/get-pip.py
else
  echo "pip already installed."
fi

# Install Ansible
if ! which ansible > /dev/null 
then
  echo "installing ansible"
  python3 -m pip install ansible
  ansible-galaxy collection install community.general
  ansible galaxy collection install ansible.posix
else
  echo "ansible already installed."
fi

# Run playbook
ansible-playbook playbook.yaml --diff
