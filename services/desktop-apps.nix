
{ config, pkgs, ... } : {
  environment.systemPackages = with pkgs; [
    firefox-devedition-bin
    gimp
    gimpPlugins.gap
    inkscape
    krita
    yed
    mpv
    spotify
    discord
  ];
}
