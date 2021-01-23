{ config, pkgs, ... } : {
  networking.hostName = "enki";

  imports = [
    ./hardware-configuration.nix

    ../users/dominic.nix

    ../services/base.nix
    ../services/grub-savedefault.nix
    ../services/sound.nix
    ../services/ssh.nix
    ../services/sway.nix
    ../services/steam.nix
    ../services/desktop-apps.nix
    ../services/android.nix
  ];

  system.stateVersion = "20.09";
}
