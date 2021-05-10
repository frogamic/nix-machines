{ config, pkgs, ... } : {
  networking.hostName = "ninhursag";

  imports = [
    ./hardware-configuration.nix

    ../../users/dominic.nix

    ../../services/base.nix
    ../../services/fingerprint.nix
  ];

  system.stateVersion = "20.09"; # Did you read the comment?
}

