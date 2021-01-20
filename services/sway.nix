{ config, pkgs, lib, ...} : {
  services.xserver.displayManager.gdm = {
    #enable = true;
    wayland = true;
  };

  programs.sway = {
    enable = true;
    extraOptions = [ "--config" "${./sway.conf}" ];
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

  environment.etc."sway.config".enable = false;
}
