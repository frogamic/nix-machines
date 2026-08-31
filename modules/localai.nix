{ config, lib, pkgs, ... }:
	let
		inherit (lib) mkEnableOption mkIf;
		cfg = config.mine.localAiServer;
	in
{
	options.mine.localAiServer = {
		enable = mkEnableOption "Local AI server";
	};

	config = mkIf cfg.enable {
		services = {
			ollama = {
				enable = true;
				#home = "/mnt/persist/ollama";
				host = "0.0.0.0";
				openFirewall = true;
				package = pkgs.ollama-rocm;
			};
			open-webui = {
				enable = true;
				host = "0.0.0.0";
				openFirewall = true;
				#stateDir = "/mnt/persist/open-webui";
				environment = {
					OLLAMA_API_BASE_URL = "http://127.0.0.1:${toString config.services.ollama.port}";
					WEBUI_AUTH = "False";
				};
			};
			searx = {
				enable = true;
				settings = {
					server = {
						port = 8081;
						bind_address = "0.0.0.0";
						secret_key = "super_secret_key";
					};
					search.formats = [
						"html"
						"json"
					];
				};
				openFirewall = true;
			};
		};
	};
}
