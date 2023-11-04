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

		nodejs
		yarn

		go
		gopls

		rustc
		rustfmt
		cargo
		clippy
		gcc

		morph
		deploy-rs
	]);
}
