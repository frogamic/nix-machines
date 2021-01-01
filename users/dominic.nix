{ config, pkgs, ... } : {
  imports = [ ../secrets/dominic.nix ];

  users.users.dominic = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
}
