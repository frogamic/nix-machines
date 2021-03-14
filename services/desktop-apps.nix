{ pkgs, ... } : {
  # Required for Discord
  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      BROWSER = "firefox-devedition";
    };
    systemPackages =
    (with pkgs; [
      xdg-utils
      firefox-devedition-bin
      gimp
      gimpPlugins.gap
      inkscape
      krita
      # yed
      spotify
      discord
      mpv
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
