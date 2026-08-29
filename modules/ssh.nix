let
	myDefault = (import ../lib).mkDefault;
in
{
	services.openssh = {
		enable = myDefault true;
		startWhenNeeded = myDefault true;
		settings = {
			PasswordAuthentication = myDefault false;
			KbdInteractiveAuthentication = myDefault false;
		};
	};
}
