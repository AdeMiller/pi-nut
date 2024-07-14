# Pi-NUT

Pi-NUT is an Ansible playbook and tools for deploying 
[Network UPS Tools, NUT](https://networkupstools.org/documentation.html) 
clients/monitors and servers onto Raspberry Pis. It supports configuration of many
UPSes with automated discovery of UPS devices connected to each Raspberry Pi 
based NUT server.



## WebNUT UPS Viewer

It uses a fork of [WebNUT](https://github.com/rshipp/webNUT) to show a list of
all UPS devices with their status and battery charge. This fork includes 
support for multiple UPS servers and other minor improvements.

![UPS Device Lists](screenshots/ups_devices.png)

Each UPS has a details page showing all the exposed NUT fields:

![UPS Device Detail](screenshots/ups_details.png)

## NUT UPS Monitor

The NUT monitor responds to server UPS events by running arbitrary commands in
response to each event. Events available are:

|   Event    | Description                                        |
| :--------: | -------------------------------------------------- |
| `online  ` | UPS on line power.                                 |
| `onbatt  ` | UPS on battery.                                    |
| `lowbatt ` | UPS battery is low.                                |
| `fsd     ` | UPS forced shutdown in process.                    |
| `commok  ` | UPS communication is OK.                           |
| `commbad ` | UPS communication is lost.                         |
| `shutdown` | Logout and shutdown ongoing.                       |
| `replbatt` | UPS battery need replacing.                        |
| `nocomm  ` | UPS is not available.                              |
| `noparent` | The upsmon process has died, shutdown not possible |

See the nut_monitor section for further details of how this is configured.

# Ansible Project Overview

The Ansible project is laid out according to the Ansible 
[Sample directory layout](https://docs.ansible.com/ansible/latest/user_guide/sample_setup.html) 
and contains the following playbooks.

## nut_server

NUT servers collect data from connected UPS devices. A NUT server can support 
several UPS devices, limited by the number of available USB connections 
available on the Raspberry Pi. 

The host_vars file for each server can be configured to override the default
driver and description for the UPS. The device IDs are extracted from the results
returned by `lsusb`.
```
ups_configs:
  "<device id>": 
    desc: "<description>"
    driver: "<driver>"
```

Each server can also be configured with a heartbeat UPS device which generates
status for a dummy UPS.

## nut_monitor

The NUT monitor connects to all NUT servers and monitors the UPS devices 
connected to them. The monitor server's host_vars file is configured to enable
events by setting them in the `nut_events` var:
```
nut_events: ["online", "onbatt", "lowbatt"]
```
Events values are always lowercase.

The host_vars file also contains configuration for actions which can be wired 
up to events on each UPS.

```
nut_actions:
  "ups-1@nut-a.mydomain.com": 
    online: "echo ONLINE"
  "ups-1@nut-b.mydomain.com":
    online: "echo ONLINE"
    onbatt: "echo ONBATT"
  "ups-1@nut-c.mydomain.com":
    online: "echo ONLINE"
      lowbatt: "echo LOWBATT" 
```

## nut_web

The NUT web server connects to all NUT servers and displays the state of all 
UPS devices. The WebNUT is a Python3 application running on the [Pyramid Web Framework](https://docs.pylonsproject.org/projects/pyramid/en/latest/index.html). 
The install footprint is quite large so the Raspberry Pi requires at least a 
4Gb SD card for a full install.

# Setup

Copy `hosts.example` to `hosts` and edit it. Each UPS should be connected to a 
NUT server, servers can support more than one UPS. Set `heartbeat_enabled=true`
to configure a heartbeat UPS on each server. 

Additional settings for each host can be set in individual 
`host_vars/<hostname>.yaml`. See `host_vars.example.yaml` for more details.

The `group_vars/all.yaml` file contains other global settings.

The NUT monitor and NUT web can be installed on the same host, which can also be 
a NUT server.

# References

Other useful pages related to this project:

* [UPS Server on Raspberry Pi](https://www.reddit.com/r/homelab/comments/5ssb5h/ups_server_on_raspberry_pi/)
* [NUT Introduction to Network UPS Tools: Configuration Examples](http://rogerprice.org/NUT/ConfigExamples.A5.pdf)