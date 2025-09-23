{ config, ... }:
let
	myDefault = (import ../lib).mkDefault;
in
{
	programs.zsh = {
		enable = myDefault true;
		histFile = myDefault "$HOME/.local/share/zsh/.histfile";
	};

	time.timeZone = myDefault "Australia/Melbourne";
	i18n.defaultLocale = myDefault "en_AU.UTF-8";

	services.xserver.xkb = {
		layout = myDefault "us";
		variant = myDefault "dvorak";
		options = myDefault "caps:swapescape";
	};

	console = {
		font = myDefault "Lat2-Terminus16";
		useXkbConfig = myDefault true;
	};

	environment = {
		shellAliases = {
			ll = "ls -alh";
		};
		variables = {
			EDITOR = myDefault "vim";
		};
	};

	impermanence.persistence.user = {
		directories = [
			".cache/zsh"
			".local/share/zsh"
		];
	};
}
