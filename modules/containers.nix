{ config, lib, pkgs, ... }:

let
	inherit (lib) mkIf mkEnableOption mkOption types;
	cfg = config.mine.containers;
in
{
	options.mine.containers = {
		enable = mkEnableOption "container support";

		registries = mkOption {
			default = [
				"docker.io"
				"quay.io"
			];
			example = [ "ghcr.io" ];
			description = "Add registries to container registry config. Registries will be searched in order for unqualified images";
			type = with types; listOf(str);
		};
	};

	config = mkIf cfg.enable {
		virtualisation = {
			containers = {
				enable = true;
				registries.settings = {
					unqualified-search-registries = cfg.registries;
					registry = map (location: { inherit location; }) cfg.registries;
				};
			};
			podman = {
				enable = true;
				dockerCompat = true;
				dockerSocket.enable = true;
			};
		};
		environment = {
			systemPackages = with pkgs; [
				buildah
				podman-compose
				(pkgs.writeShellScriptBin "docker" ''
					if [ "''${1}" == "compose" ]; then
						exec ${podman-compose}/bin/podman-compose "''${@:2}"
					else
						exec ${config.virtualisation.podman.package}/bin/podman "''${@:1}"
					fi
				'')
			];
		};
	};
}
