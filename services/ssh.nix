{ config, pkgs, ... } : {
	services.openssh = {
		enable = true;
		startWhenNeeded = true;
		passwordAuthentication = false;
		kbdInteractiveAuthentication = false;
	};
}
