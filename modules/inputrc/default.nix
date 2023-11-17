{ lib, config, ... }:
	let
		inherit (lib) mkDefault mkIf mkOption types;
		cfg = config.environment.inputrc;
	in
	{
		options.environment.inputrc.extraConfig = mkOption {
			default = "";
			description = ''
				Extra config to be appended to the /etc/inputrc file
			'';
			type = types.lines;
		};

		config = mkIf (cfg.extraConfig != "") {
			environment.etc.inputrc.text = mkDefault ((builtins.readFile ./inputrc) + cfg.extraConfig);
		};
	}
