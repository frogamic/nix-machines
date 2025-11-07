{ pkgs, ... }: {
	environment.systemPackages = with pkgs; [
		opencode
		claude-code
		claude-monitor
		gemini-cli-bin
	];
}
