{ config, lib, pkgs, ... } : {
	system.autoUpgrade = {
		enable = true;
		dates = "23:00";
		flake = "github:frogamic/nix-machines";
		flags = [
			"--no-write-lock-file"
			"-L"
		];
	};

	systemd.services.nixos-upgrade.script = lib.mkOverride 50 ''
		${config.system.build.nixos-rebuild}/bin/nixos-rebuild boot ${toString config.system.autoUpgrade.flags}
		${config.nix.package.out}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +10
		${config.nix.package.out}/bin/nix-collect-garbage --quiet
		/nix/var/nix/profiles/system/bin/switch-to-configuration switch
	'';

	environment.systemPackages = [(
		pkgs.writeShellScriptBin "nixos-upgrade" ''
		${config.systemd.package}/bin/journalctl -f -u nixos-upgrade.service -n 0 &
		jpid="$!"
		${config.systemd.package}/bin/systemctl start nixos-upgrade.service
		sleep 0.5s
		kill "$jpid"
		''
	)];
}
