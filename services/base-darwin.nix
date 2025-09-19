{ pkgs, lib, ... }:
let
	inherit (lib) mkDefault mkAfter;
in

{
	environment.systemPackages = with pkgs; [
		yq-go
		jq
		yj
		ripgrep
		fzf
		bat
		tree
		pstree
		pv
		ffmpeg
		ntfs3g
		dos2unix

		gnupg
		pinentry_mac

		obsidian
	];

	# Required for Obsidian
	nixpkgs.config.allowUnfree = true;

	homebrew = {
		enable = mkDefault true;
		onActivation = {
			cleanup = mkDefault "uninstall";
			upgrade = mkDefault true;
			autoUpdate = mkDefault true;
		};
		global.autoUpdate = mkDefault false;
	};

	programs = {
		gnupg.agent.enable = mkDefault true;

		zsh = {
			enable = mkDefault true;
			interactiveShellInit = mkAfter ''
				source ${pkgs.fzf}/share/fzf/completion.zsh
				source ${pkgs.fzf}/share/fzf/key-bindings.zsh
			'';
		};
		bash.interactiveShellInit = mkAfter ''
			source ${pkgs.fzf}/share/fzf/completion.bash
			source ${pkgs.fzf}/share/fzf/key-bindings.bash
		'';
		nix-index-database.comma.enable = true;
	};

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = mkDefault true;

	nix = {
		settings = {
			trusted-users = mkDefault [
				"@admin"
			];
			experimental-features = mkDefault ["nix-command" "flakes"];
		};
		configureBuildUsers = mkDefault true;
		gc = {
			automatic = mkDefault true;
		};
	};

	system.keyboard = {
		enableKeyMapping = mkDefault true;
		remapCapsLockToEscape = mkDefault true;
	};

	security.pam.enableSudoTouchIdAuth = mkDefault true;
}
