{ config, lib, pkgs, ... }:

let
	inherit (lib) length mkOption optionals singleton types;
	inherit (builtins) filter concatStringsSep;

	maybePrefix = prefix: maybeStr: if maybeStr == null then null else ''${prefix}"${maybeStr}"'';

	cfg = config.mine.hardware.udev-hidraw-rules;
in

{
	options.mine.hardware.udev-hidraw-rules = mkOption {
		description = "A list of udev rules to add uaccess to devices";
		type = with types; listOf (submodule {
			options = {
				vendor = mkOption {
					description = "The idVendor attribute to match";
					type = nullOr str;
				};
				product = mkOption {
					description = "The idProduct attribute to match";
					type = nullOr str;
				};
				mode = mkOption {
					description = "The mode to apply to matched devices";
					type = nullOr str;
				};
				group = mkOption {
					description = "The group to own matched devices";
					type = nullOr str;
				};
			};
		});
	};

	config.services.udev.packages = optionals ((length cfg) > 0) (
		singleton (
			pkgs.writeTextFile {
				name = "hidraw-udev-uaccess-rules";
				destination = "/etc/udev/rules.d/70-hidraw-udev-uaccess.rules";
				text = concatStringsSep "\n" (
					map ({vendor, product, mode, group}:
						concatStringsSep ", " (
							filter (s: s != null) [
								''SUBSYSTEM=="hidraw"''
								(maybePrefix "ATTRS{idVendor}==" vendor)
								(maybePrefix "ATTRS{idProduct}==" product)
								(maybePrefix "MODE=" mode)
								(maybePrefix "GROUP=" group)
								''TAG+="uaccess"''
							]
						)
					) cfg
				);
			}
		)
	);
}
