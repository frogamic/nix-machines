{ config, lib, pkgs, ... }:
let
	inherit (lib) mkBefore mkIf mkEnableOption mkOption optionals types;

	mkDisableOption = name: mkOption {
		default = true;
		example = false;
		description = "Whether to enable ${name}";
		type = types.bool;
	};

	cfg = config.mine.gaming;
in
{
	options.mine.gaming = {
		enable = mkEnableOption "gaming defaults";
		heroic.enable = mkDisableOption "Heroic launcher";
		mangohud.enable = mkDisableOption "Mangohud overlay";
		gamescope.enable = mkDisableOption "gamescope microcompositor";
		steam = {
			enable = mkDisableOption "Steam launcher";
			hardware.enable = mkDisableOption "Steam hardware";
		};
	};

	config = mkIf cfg.enable {

		nixpkgs.config.allowUnfree = true;

		environment.systemPackages = with pkgs; [
			winetricks
			protontricks
		] ++ (optionals cfg.steam.enable [ steamcmd ])
			++ (optionals cfg.mangohud.enable [ mangohud ])
			++ (optionals cfg.heroic.enable [ heroic ]);

		programs = {
			steam = mkIf cfg.steam.enable {
				enable = true;
				localNetworkGameTransfers.openFirewall = true;
				remotePlay.openFirewall = true;
			};
			gamescope = mkIf cfg.gamescope.enable {
				enable = true;
				enableWsi = true;
			};
		};

		systemd.tmpfiles.settings."00-x11-unix" = mkIf cfg.gamescope.enable {
			"/tmp/.X11-unix"."D!" = {
				mode = "1777";
				user = config.users.users.me.name;
				group = config.users.users.me.group;
				age = "10d";
			};
		};

		hardware.steam-hardware.enable = cfg.steam.hardware.enable;

		impermanence.persistence.user.directories = [
			".local/share/vulkan"
			".cache/mesa_shader_cache"
		] ++ (optionals cfg.steam.enable [
			".steam"
			".local/share/Steam"
		]) ++ (optionals cfg.heroic.enable [
			".local/share/Heroic"
		]);
	};
}
