{ pkgs, ... } : {
  fonts.fonts = with pkgs; [
    font-awesome
  ];
  environment.systemPackages = [
    pkgs.waybar
  ];
}
