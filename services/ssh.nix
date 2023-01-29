{ config, pkgs, ... } : {
	services.openssh = {
		enable = true;
		startWhenNeeded = true;
		settings = {
			passwordAuthentication = false;
			kbdInteractiveAuthentication = false;
		};
	};
}
