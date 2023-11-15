{ stdenv, coreutils, gawk, gnused, gnugrep, python3, perl, deno }:
	dirName: hostName: fileName: attrs:
		stdenv.mkDerivation ({
			args = [ ./mkConfig.sh fileName hostName ];
			baseInputs = [ coreutils gawk gnused gnugrep ];
			buildInputs = [ python3 perl deno ];
			name = fileName;
			src = [ dirName ];
		} // attrs)
