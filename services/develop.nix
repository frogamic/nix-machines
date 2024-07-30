{ pkgs, ... } : {

	imports = [
		./hardware-dev.nix
		./aws.nix
		./podman.nix
	];

	environment.systemPackages = (with pkgs; [
		vim
		gitFull
		git-lfs
		git-crypt
		python3
		perl
		powershell

		nodejs
		yarn

		go
		gopls

		rustc
		rustfmt
		cargo
		clippy

		gcc
		gnumake

		morph
		deploy-rs
	]);
}
