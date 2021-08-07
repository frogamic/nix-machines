nixpkgs: folder: extra:
	with builtins;
	let
		removeSuffix = suffix: str:
			let
				sufLen = stringLength suffix;
				sLen = stringLength str;
			in
				if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str then
					substring 0 (sLen - sufLen) str
				else
					str;
		callPackage = path: {
			name = removeSuffix ".nix" (baseNameOf path);
			value = nixpkgs.callPackage path extra;
		};
		packageFolders = import ./nixImportable.nix folder;
	in
		listToAttrs (map callPackage packageFolders)
