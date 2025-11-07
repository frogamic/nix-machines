{ pkgs, lib, config, ... }:
let
	inherit (lib) mkDefault mkAfter;
in

{
	environment = {
		systemPath = lib.mkAfter [
			config.homebrew.brewPrefix
		];
		systemPackages = with pkgs; [
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
	};

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
		casks = [ "bluesnooze" ];
	};

	programs = {
		gnupg.agent.enable = mkDefault true;

		zsh = {
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

	nix = {
		enable = true;
		settings = {
			trusted-users = mkDefault [
				"@admin"
			];
			experimental-features = mkDefault ["nix-command" "flakes"];
		};
		gc = {
			automatic = mkDefault true;
		};
	};

	system = {
		keyboard = {
			enableKeyMapping = mkDefault true;
			remapCapsLockToEscape = mkDefault true;
		};
		defaults.CustomUserPreferences.NSGlobalDomain = {
			# Tighten up the menubar icon spacing
			NSStatusItemSpacing = 1;
			NSStatusItemSelectionPadding = 1;

			# Autoswitch light/dark mode
			AppleInterfaceStyleSwitchesAutomatically = 1;

			# Disable autocorrect
			NSAutomaticCapitalizationEnabled = 0;
			NSAutomaticDashSubstitutionEnabled = 0;
			NSAutomaticInlinePredictionEnabled = 0;
			NSAutomaticPeriodSubstitutionEnabled = 0;
			NSAutomaticQuoteSubstitutionEnabled = 0;
			NSAutomaticSpellingCorrectionEnabled = 0;
			WebAutomaticSpellingCorrectionEnabled = 0;
			# NSSpellCheckerContainerTransitionComplete = 1;
			# NSSpellCheckerDictionaryContainerTransitionComplete = 1;
		};
	};

	security.pam.services.sudo_local.touchIdAuth = mkDefault true;
}
