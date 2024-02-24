let
	myDefault = (import ../lib).mkDefault;
in
{
	programs.zsh.enable = myDefault true;

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
			nr = "function my_nr() { nix run \"nixpkgs#$1\" -- \"\${@:2}\"; }; my_nr";
			nru = "function my_nr() { NIXPKGS_ALLOW_UNFREE=1 nix run \"nixpkgs#$1\" --impure -- \"\${@:2}\"; }; my_nr";
		};
		variables = {
			EDITOR = myDefault "vim";
		};
	};
}
