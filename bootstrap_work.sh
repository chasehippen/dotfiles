#!/bin/bash

# Install Ansible
python3 -m pip install ansible
ansible-galaxy collection install community.general

# Run playbook
ansible-playbook playbook.yaml --diff --tags work
