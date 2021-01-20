{ config, pkgs, ... } : {
  networking.hostName = "ninhursag";

  imports = [
    ./hardware-configuration.nix

    ../users/dominic.nix

    ../services/base.nix
    ../services/sound.nix
    ../services/ssh.nix
    ../services/sway.nix
    ../services/steam.nix
    ../services/desktop-apps.nix
  ];

  system.stateVersion = "20.09"; # Did you read the comment?
}

