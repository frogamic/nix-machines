
{ config, pkgs, ... } : {
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
      mpv
      spotify
      discord
    ];
  };
}
