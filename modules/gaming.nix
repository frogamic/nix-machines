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
		steam = {
			enable = mkDisableOption "Steam launcher";
			hardware.enable = mkDisableOption "Steam hardware";
		};
	};
	config = mkIf cfg.enable {

		nixpkgs.config.allowUnfree = true;

		environment.systemPackages = (optionals cfg.steam.enable [ pkgs.steamcmd ]) ++ (optionals cfg.heroic.enable [ pkgs.heroic ]);

		programs.steam = lib.mkIf cfg.steam.enable {
			enable = true;
			localNetworkGameTransfers.openFirewall = true;
			remotePlay.openFirewall = true;
		};

		hardware.steam-hardware.enable = cfg.steam.hardware.enable;

		impermanence.persistence.user.directories = [
			".local/share/vulkan"
			".cache/mesa_shader_cache"
			".cache/radv_builtin_shaders"
		] ++ (optionals cfg.steam.enable [
			".steam"
			".local/share/Steam"
		]) ++ (optionals cfg.heroic.enable [
			".local/share/Heroic"
		]);
	};
}
