{ config, pkgs, ... } : {
  imports = [ ../secrets/dominic.nix ];

  users.users.dominic = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = import ./privileged-groups.nix config;
  };
}
