{ config, pkgs, ... } : {
  imports = [
    ./hardware-configuration.nix

    ../users/dominic.nix

    ../services/base.nix
    ../services/sound.nix
    ../services/ssh.nix
    ../services/bspwm.nix
    ../services/steam.nix
    ../services/desktop-apps.nix
  ];

  networking = {
    hostName = "ninhursag";
    wireless.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    useDHCP = false;
    interfaces = {
      wlp3s0.useDHCP = true;
      enp2s0f0.useDHCP = true;
    };
    supplicant.wlp3s0 = {
      userControlled.enable = true;
      configFile = {
        path = "/etc/wpa_supplicant.conf";
        writable = true;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

