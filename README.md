# NixOS Machines Configuration

This repository contains my configurations for my Linux PCs that run [NixOS](https://nixos.org).

### Quickstart

To get up and running quickly, run the following in a shell on a NixOS system:

```bash
nixos-rebuild switch --no-write-lock-file --flake github:frogamic/nix-machines
```

# Repository Structure

## Configuration

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

This is where users accounts are configured. Since my PCs are all single user there is only me.

## Overlay

Part of this configuration is an extension to nixpkgs in the form of an overlay supplying `mypkgs` and `mylib`, and a set of modules providing their own options.

### lib

Helper functions to build out the module. Output from the flake as `.lib`.

### mylib

Helper functions that depend on nixpkgs, intended to be used via the included default overlay like `nixpkgs.mylib.<fn>`.

### pkgs

Extra packages, available under `mypkgs` in the overlay.

### Modules

Extra modules to provide more generalised extra configuration for my machines and theoretically other consumers of this flake.
Technically there is no difference between these and those in `services` except for the intent.
