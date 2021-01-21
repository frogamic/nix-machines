{ config, pkgs, lib, ...} : let
  XKB_DEFAULT_LAYOUT = if config.services.xserver ? layout
    then "export XKB_DEFAULT_LAYOUT=\"${config.services.xserver.layout}\""
    else "";
  XKB_DEFAULT_OPTIONS = if config.services.xserver ? xkbOptions
    then "export XKB_DEFAULT_OPTIONS=\"${config.services.xserver.xkbOptions}\""
    else "";
  XKB_DEFAULT_VARIANT = if config.services.xserver ? xkbVariant
    then "export XKB_DEFAULT_VARIANT=\"${config.services.xserver.xkbVariant}\""
    else "";
in {
  services.xserver.displayManager.gdm = {
    #enable = true;
    wayland = true;
  };

  programs.sway = {
    enable = true;
    extraOptions = [ "--config" "${./sway.conf}" ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      ${XKB_DEFAULT_LAYOUT}
      ${XKB_DEFAULT_OPTIONS}
      ${XKB_DEFAULT_VARIANT}
    '';
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland
      mako
      wl-clipboard
      alacritty
      wofi
    ];
  };

  environment.etc."sway/config".enable = false;
}
