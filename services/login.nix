{ lib, config, ... }:

let
	myDefault = (import ../lib).mkDefault;
in

{
	services.getty = {
		extraArgs = [
			"--nohostname"
			"-n"
		];
		loginOptions = myDefault config.users.users.me.name;
	};

	environment.etc.issue = lib.mkForce {
		# hostname:tty
		text = ''

\e{red}\n\e{darkgray}\l\e{reset}

'';
	};
}
