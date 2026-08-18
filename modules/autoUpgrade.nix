{ config, lib, pkgs, ... }:
let
	inherit (lib) mkIf mkEnableOption mkOption types;

	myDefault = (import ../lib).mkDefault;

	cfg = config.mine.autoUpgrade;
in
{
	options.mine.autoUpgrade = {

		enable = mkEnableOption "my customized autoUpgrade options";

		flake = mkOption {
			description = "The Flake URI of the NixOS configuration to build";
			default = "github:frogamic/nix-machines";
			example = "gitlab:my-user/my-repo/my-branch";
			type = types.str;
		};

	};

	config = mkIf cfg.enable {

		system.autoUpgrade = {
			enable = true;
			dates = myDefault "23:00";
			flake = cfg.flake;
			flags = [
				"--no-write-lock-file"
				"--print-build-logs"
			];
			runGarbageCollection = myDefault true;
		};

		services.angrr = myDefault {
			enable = true;
			settings.profile-policies.system = {
				profile-paths = [ "/nix/var/nix/profiles/system" ];
				keep-since = "14d";
				keep-latest-n = 10;
				keep-booted-system = true;
				keep-current-system = true;
			};
		};

		environment.systemPackages = [(
			pkgs.writeShellScriptBin "nixos-upgrade" ''
				${config.systemd.package}/bin/journalctl -f -u nixos-upgrade.service -n 0 &
				jpid="$!"
				${config.systemd.package}/bin/systemctl start nixos-upgrade.service
				sleep 0.5s
				kill "$jpid"
			''
		)];
	};
}
