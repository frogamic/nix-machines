# NixOS Machines Configuration

This repository contains my configurations for my Linux PCs that run [NixOS](https://nixos.org)

### Quickstart

To get up and running quickly, run the following in a shell on a NixOS system:

```bash
git clone https://github.com/frogamic/nix-machines
cd nix-machines
mkdir "machines/$(hostname)"
vim "users/$(whoami).nix"
# Setup your user account
vim machines/$(hostname)/{hardware-,}configuration.nix
# Build out your machine by importing services and users
# check an existing machine for ideas
sudo su -c './install && nixos-rebuild switch --upgrade'
```

The `install` script takes a single optional parameter to select which configuration to install, by default it uses the hostname of the current system. It installs the configuration by symlinking it (by absolute path) to `/etc/nixos/configuration.nix`.

## Repository Structure

### machines

This folder contains the machine specific configurations inside subfolders. Each subfolder should be named after the machine's hostname.

Each folder will contain at minimum a `configuration.nix`, and probably a `hardware-configuration.nix` (unless you want to be a rebel and eschew the tradition of splitting arbitrary bits of config into another file for not much reason). Additionally these folders can contain configs or partial configs for services that differ between the different machines supported (more on that in the `lib` section).

### services

This is where the bulk of the config sits. Each file here should be a nix module that fully encapsulates a "service" or bundle of packages and config to achieve some purpose. Alongside these services are their related configs and supporting binaries/scripts.

#### services/base.nix

This is a sort of meta-service that applies some personalisation and baseline configuration and imports a number of other services that would be common across all machines.

#### services/hardware

This is a subset of 'services' relating to specific hardware such as GPU/CPU supporting config and packages.

### users

This is where users accounts are configured. Since my PCs are all single user there is only me. There are also helper function(s) for configuring multiple similar users should it even not just be me; Cloud-scalable user config.

### secrets

This is where things I don't want you to see are stored. It's encrypted using git-crypt.

### lib

This has helper function(s) that are documented separately in their own READMEs.
