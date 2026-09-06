{ config, lib, pkgs, ... }:
	let
		inherit (lib) mkEnableOption mkIf;
		cfg = config.mine.jovian;
	in
{
	options.mine.jovian = {
		enable = mkEnableOption "Jovian-nix steam-os like experience";
	};

	config = mkIf cfg.enable {
		services.desktopManager.plasma6.enable = true;

		jovian = {
			steam = {
				enable = true;
				autoStart = true;
				desktopSession = "plasma";
				user = "steam";
			};
			steamos = {
				useSteamOSConfig = false;
				enableBluetoothConfig = true;
				enableEarlyOOM = true; # Probably disable or at least tweak this later for homelabbing
				enableHdmiCecIntegration = true;
				enableSysctlConfig = true;
			};
		};

		users.users.steam = {
			isNormalUser = true;
			shell = pkgs.zsh;
			openssh.authorizedKeys = config.users.users.me.openssh.authorizedKeys;
		};
	};
}
