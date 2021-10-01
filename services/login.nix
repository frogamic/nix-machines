{ lib, config, ... }: {
	services.getty = {
		extraArgs = [
			"--nohostname"
			"-n"
		];
		loginOptions = config.users.users.me.name;
	};

	environment.etc.issue = lib.mkForce {
		# hostname:tty
		text = ''

\e{red}\n\e{darkgray}\l\e{reset}

'';
	};
}
