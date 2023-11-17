/*
These functions are copied from nixpkgs.lib to remove the dependency on nixpkgs
*/
let
	inherit (builtins) attrNames concatMap listToAttrs stringLength substring;
in

rec {

	filterAttrs = pred: set:
		listToAttrs (
		concatMap
			(name: let value = set.${name}; in if pred name value then [{inherit name value;}] else [])
			(attrNames set)
		);

	hasPrefix = prefix: str: substring 0 (stringLength prefix) str == prefix;

	hasSuffix = suffix: str:
		let
			lenContent = stringLength str;
			lenSuffix = stringLength suffix;
		in
			lenContent >= lenSuffix && substring (lenContent - lenSuffix) lenContent str == suffix;

	removeSuffix = suffix: str:
		let
			sufLen = stringLength suffix;
			sLen = stringLength str;
		in
			if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str then
				substring 0 (sLen - sufLen) str
			else
				str;

}
