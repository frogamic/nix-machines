{ pkgs, ... } : {
	nix.settings = {
		experimental-features = ["nix-command" "flakes"];
		keep-derivations = true;
		keep-outputs = true;
		show-trace = true;
	};
}
