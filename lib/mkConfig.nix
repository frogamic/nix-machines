{ pkgs, config, ... } : file : attrs : let
	fileName = builtins.baseNameOf file;
	dirName = builtins.dirOf file;
in with pkgs; let
	defaultAttrs = {
		args = [ ./mkConfig.sh ];
		baseInputs = [ coreutils gawk gnused gnugrep ];
		buildInputs = [ python3 perl deno nodejs ];
		name = fileName;
		src = [
			file
		] ++ (
			let
				hostpath = "${dirName}/${config.system.name}/${fileName}";
			in if builtins.pathExists hostpath then
				[ hostpath ]
			else
				[ ]
		);
	};
in stdenv.mkDerivation (config.environment.variables // defaultAttrs // attrs)
