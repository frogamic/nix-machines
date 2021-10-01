{ lib, config, ... }: {
	services.getty.extraArgs = [
		"--nohostname"
	];

	environment.etc.issue = lib.mkForce {
		# hostname:tty
		text = ''

\e{red}\n\e{darkgray}\l\e{reset}

'';
	};
}
