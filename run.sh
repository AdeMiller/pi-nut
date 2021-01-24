#!/bin/sh

set -e 

ansible-galaxy collection install community.general
ansible-playbook site.yaml
