# Pi-NUT
Raspberry Pi NUT infrastructure configuration with Ansible.

# Project Overview

The Ansible project is laid out according to the Ansible [Sample directory layout](https://docs.ansible.com/ansible/latest/user_guide/sample_setup.html) and contains the following playbooks.

## nut_client

The NUT client connects to all NUT servers and monitors the UPS devices 
connected to them. 

## nut_server

NUT servers collect data from connected UPS devices. A NUT server can support several UPS devices, limited by the number of available USB connections available on the Raspberry Pi.

## nut_web

The NUT web server connects to all NUT servers and displays the state of all UPS devices. 

# Setup

Copy `hosts.example` to `hosts` and edit it. Each UPS should be connected to a NUT server, servers can support more than one UPS. Each server is also configured with a dummy UPS which generates Heartbeat events for end-to-end testing.

The NUT client and NUT web can be installed on the same host, which can also be a NUT server.
