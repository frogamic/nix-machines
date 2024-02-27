{ pkgs, ... }: {

	hardware.nitrokey.enable = true;

	environment.systemPackages = with pkgs; [
		# pynitrokey
		# nitrokey-app2
		opensc
		pcsctools
	];

	services.pcscd = {
		enable = true;
	};
}
