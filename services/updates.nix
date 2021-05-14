{ lib, config, ... } : {
  system.autoUpgrade = {
    enable = true;
    dates = "23:00";
    flake = "github:frogamic/nix-machines";
    flags = [
      "--impure"
      "--no-write-lock-file"
    ];
  };

  systemd.services.nixos-upgrade.script = lib.mkOverride 50 ''
    ${config.system.build.nixos-rebuild}/bin/nixos-rebuild boot ${toString config.system.autoUpgrade.flags}
    ${config.nix.package.out}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +10
    ${config.nix.package.out}/bin/nix-collect-garbage --quiet
    /nix/var/nix/profiles/system/bin/switch-to-configuration boot
  '';
}
