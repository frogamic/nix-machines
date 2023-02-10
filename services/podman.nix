{ pkgs, config, ... } : {
	virtualisation.podman = {
		enable = true;
		dockerCompat = true;
		dockerSocket.enable = true;
	};
	environment = {
		systemPackages = with pkgs; [
			buildah
			podman-compose
			(pkgs.writeShellScriptBin "docker" ''
				if [ "''${1}" == "compose" ]; then
					${podman-compose}/bin/podman-compose "''${@:2}"
				else
					${config.virtualisation.podman.package}/bin/podman "''${@:1}"
				fi
			'')
		];
	};
}
