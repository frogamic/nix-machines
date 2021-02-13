{ config, pkgs, ... } :  {
  # Required for Discord
  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      BROWSER = "firefox-devedition";
    };
    systemPackages =
    (with import ../lib/pkgs-stable.nix; [
      mpv
    ]) ++
    (with pkgs; [
      xdg-utils
      firefox-devedition-bin
      gimp
      gimpPlugins.gap
      inkscape
      krita
      yed
      spotify
      discord
      breeze-gtk
      breeze-qt5
      breeze-icons
    ]) ++
    (with pkgs.xfce; [
      xfconf
      exo
      thunar
      thunar-volman
      thunar-archive-plugin
      tumbler
    ]);
  };
}
