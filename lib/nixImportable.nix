path:

with builtins;

let
	inherit (import ./.lib.nix) filterAttrs hasPrefix hasSuffix;
in

map
	(folder: path + "/${folder}")
	(attrNames
		(filterAttrs
			(name: type:
				(! (hasPrefix "." name))
				&& (
						(type == "directory" && pathExists (path + "/${name}/default.nix"))
					||
						(type == "regular" && (hasSuffix ".nix" name) && name != "default.nix")
					)
			)
			(readDir path)
		)
	)
