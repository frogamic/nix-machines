# NixOS Machines Configuration

This repository contains my configurations for my Linux PCs that run [NixOS](https://nixos.org).

### Quickstart

To get up and running quickly, run the following in a shell on a NixOS system:

```bash
nixos-rebuild switch --impure --no-write-lock-file --flake github:frogamic/nix-machines
```

## Repository Structure

### machines

This folder contains the machine specific configurations. Each configuration should be named after the machine's hostname. I am not using hardware-configuration per machine.

### services

This is where the bulk of the config sits. Each file here should be a nix module that fully encapsulates a "service" or bundle of packages and config to achieve some purpose.

#### services/base.nix

This is a sort of meta-service that applies some personalisation and baseline configuration and imports a number of other services that would be common across all machines.

#### services/hardware

This is a subset of 'services' relating to specific hardware such as GPU/CPU supporting config and packages.

### config

This is for config files that are consumed by services and built into the nix-store.

### bin

This is where executable files that will be included in the build are stored.

### users

This is where users accounts are configured. Since my PCs are all single user there is only me. There are also helper function(s) for configuring multiple similar users should it even not just be me; Cloud-scalable user config.

### lib

This has helper function(s) that are documented separately in their own READMEs.
