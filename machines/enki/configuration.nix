{ config, pkgs, ... } : {
  networking.hostName = "enki";

  imports = [
    ./hardware-configuration.nix

    ../../users/dominic.nix

    ../../services/base.nix
    ../../services/grub-savedefault.nix
  ];

  system.stateVersion = "20.09";
}
