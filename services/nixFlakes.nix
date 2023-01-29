{ pkgs, ... } : {
	nix.extraOptions = ''
		experimental-features = nix-command flakes
		extra-experimental-features = nix-command
	'';
}
