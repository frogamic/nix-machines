{ config, pkgs, ...} : let
  XKB_DEFAULT_LAYOUT = if config.services.xserver ? layout
    then "export XKB_DEFAULT_LAYOUT=\"${config.services.xserver.layout}\""
    else "";
  XKB_DEFAULT_OPTIONS = if config.services.xserver ? xkbOptions
    then "export XKB_DEFAULT_OPTIONS=\"${config.services.xserver.xkbOptions}\""
    else "";
  XKB_DEFAULT_VARIANT = if config.services.xserver ? xkbVariant
    then "export XKB_DEFAULT_VARIANT=\"${config.services.xserver.xkbVariant}\""
    else "";
  sway-conf = import ../lib/mkConfig.nix { inherit pkgs config; } ./config/sway.conf {};
  pacycle = pkgs.writeScriptBin "pacycle" (builtins.readFile ./bin/pacycle);
in {
  services.xserver.displayManager.gdm = {
    #enable = true;
    wayland = true;
  };

  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      ${XKB_DEFAULT_LAYOUT}
      ${XKB_DEFAULT_OPTIONS}
      ${XKB_DEFAULT_VARIANT}
    '';
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      playerctl
      pamixer
      pacycle
      wob
      swaylock
      swayidle
      xwayland
      mako
      libnotify
      wl-clipboard
      wofi
      alacritty
    ];
  };

  environment.etc."sway/config".source = sway-conf;
}
