{ config, pkgs, ... } : {
  nixpkgs.config.allowUnfree = true;

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
}
