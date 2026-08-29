let
	myDefault = (import ../lib).mkDefault;
in
{
	nix.settings = {
		experimental-features = myDefault ["nix-command" "flakes"];
		keep-outputs = myDefault true;
		show-trace = myDefault true;
	};
}
