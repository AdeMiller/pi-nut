#!/bin/bash

set -e 

ansible_args=""
while getopts ":uv" arg; do
  case $arg in
    u)
      echo -e "\n\e[32mPi upgrade\e[39m"
      ansible_args="--skip-tags pi_upgrade"
      shift
      ;;
    v)
      echo -e "\n\e[32mValidation mode\e[39m"
      ansible_args="--tags validate"
      shift
      ;;
    *)
      # Pass other playbook options on.
      ;;
  esac
done
ansible_args="${ansible_args} $@"

echo -e "\n\e[32mInstall packages ...\e[39m"
ansible-galaxy collection install community.general

echo -e "\n\e[32mRun playbook ...\e[39m"
ansible-playbook site.yaml ${ansible_args}
