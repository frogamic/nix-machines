path:
	with builtins;
	let
		nameValuePair = name: value: { inherit name value; };
		filterAttrs = pred: set:
		listToAttrs
			(concatMap
				(name:
					let v = set.${name}; in
					if pred name v then [(nameValuePair name v)] else [])
				(attrNames set)
			);
		hasPrefix = prefix: str: substring 0 (stringLength prefix) str == prefix;
		hasSuffix = suffix: str:
			let
				lenContent = stringLength str;
				lenSuffix = stringLength suffix;
			in
				lenContent >= lenSuffix && substring (lenContent - lenSuffix) lenContent str == suffix;
	in
		map (folder: path + "/${folder}") (attrNames
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
