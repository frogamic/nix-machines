{ pkgs, lib, config, ... } : {
  system.autoUpgrade = {
    enable = true;
    dates = "23:00";
    channel = "https://nixos.org/channels/nixos-unstable";
  };

  systemd.services.nixos-upgrade.script = lib.mkOverride 50 ''
    ${config.system.build.nixos-rebuild}/bin/nixos-rebuild boot ${toString config.system.autoUpgrade.flags}
    ${config.nix.package.out}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +10 --quiet
    ${config.nix.package.out}/bin/nix-collect-garbage --quiet
  '';
}
