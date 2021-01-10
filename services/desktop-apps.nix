
{ config, pkgs, ... } : let
  pkgs-stable = import ./pkgs-stable.nix;
in {
  environment = {
    variables = {
      BROWSER = "firefox-devedition";
    };
    systemPackages = with pkgs; [
      firefox-devedition-bin
      gimp
      gimpPlugins.gap
      inkscape
      krita
      yed
      pkgs-stable.mpv
      spotify
      discord
    ];
  };
}
