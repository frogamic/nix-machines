{ pkgs, config, ... } : dirName : fileName : attrs :
with pkgs; let
	defaultAttrs = {
		args = [ ./mkConfig.sh fileName config.networking.hostName ];
		baseInputs = [ coreutils gawk gnused gnugrep ];
		buildInputs = [ python3 perl deno nodejs ];
		name = fileName;
		src = [ dirName ];
	};
in stdenv.mkDerivation (config.environment.variables // defaultAttrs // attrs)
