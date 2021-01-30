#!/bin/bash

set -e 

echo -e "\e[32mInstall packages ...\e[39m"
ansible-galaxy collection install community.general

echo -e "\n\e[32mRun playbook ...\e[39m"
ansible-playbook site.yaml $@
