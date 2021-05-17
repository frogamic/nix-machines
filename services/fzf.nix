{ pkgs, ... } : with pkgs; {
	programs.zsh.shellInit = ''
		source ${fzf}/share/fzf/completion.zsh
		source ${fzf}/share/fzf/key-bindings.zsh
	'';
	programs.bash.shellInit = ''
		source ${fzf}/share/fzf/completion.bash
		source ${fzf}/share/fzf/key-bindings.bash
	'';
	environment.systemPackages = [ fzf ];
}
