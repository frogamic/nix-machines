{ pkgs, config, ... } : {
	virtualisation.podman = {
		enable = true;
		dockerCompat = true;
		dockerSocket.enable = true;
	};
	environment = {
		variables = {
			DOCKER_HOST = "/run/podman/podman.sock";
		};
		systemPackages = with pkgs; [
			buildah
			docker-compose
			(pkgs.writeShellScriptBin "docker" ''
				if [ "''${1}" == "compose" ]; then
					${docker-compose}/bin/docker-compose "''${@:2}"
				else
					${config.virtualisation.podman.package}/bin/podman "''${@:1}"
				fi
			'')
		];
	};
}
