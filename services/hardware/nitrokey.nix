{ pkgs, ... }: {

	hardware.nitrokey.enable = true;

	environment.systemPackages = (with pkgs; [
		opensc
		pcsctools
	]) ++ (with pkgs.frogamic; [
		pynitrokey
		nitrokey-app2
	]);

	services.pcscd = {
		enable = true;
	};
}
