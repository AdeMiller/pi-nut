#!/bin/bash

set -e 

ansible_args="--skip-tags pi_upgrade"

while getopts ":uvw" arg; do
  case $arg in
    u)
      echo -e "\n\e[32mPi upgrade\e[39m"
      ansible_args=""
      shift
      ;;
    v)
      echo -e "\n\e[32mValidation mode\e[39m"
      ansible_args="${ansible_args} --tags validate"
      shift
      ;;
    w)
      echo -e "\n\e[32mValidation mode\e[39m"
      ansible_args="${ansible_args} --tags nut_web"
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
