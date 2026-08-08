{ pkgs, lib, ... } : rec {
	environment.systemPackages = with pkgs; [
		sbctl
		tpm2-tools
	];

	boot = {
		loader.systemd-boot.enable = lib.mkForce false;
		lanzaboote = {
			enable = true;
			pkiBundle = "/var/lib/sbctl";
		};
	};
	impermanence.persistence.directories = [
		boot.lanzaboote.pkiBundle
	];
}
