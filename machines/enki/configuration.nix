{ config, pkgs, ... } : {
  networking.hostName = "enki";

  imports = [
    ./hardware-configuration.nix

    ../../users/dominic.nix

    ../../services/base.nix
    ../../services/grub-savedefault.nix
    ../../services/texlive.nix
  ];

  system.stateVersion = "20.09";
}
