{ config, lib, ... }:

let
	inherit (lib) mkIf mkEnableOption;

	caBundle = config.security.pki.caBundle or "/etc/ssl/certs/ca-certificates.crt";
	vars = {
		ca_certificates_file = caBundle; # Various tools incl Python & gsutil/boto
		SSL_CERT_FILE = caBundle; # Various tools incl Golang
		CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE = caBundle; # gcloud
		CURL_CA_BUNDLE = caBundle; # curl
		REQUESTS_CA_BUNDLE = caBundle; # Python requests library
		HTTPLIB2_CA_CERTS = caBundle; # Python httplib2 library
		GRPC_DEFAULT_SSL_ROOTS_FILE_PATH = caBundle; # GRPC
	};

	cfg = config.mine.forceCustomCa;
in
{
	options.mine.forceCustomCa = mkEnableOption "ca bundle path injection into relevant environment variables";

	config = mkIf cfg {
		nix.envVars = vars;
		environment.variables = vars;
	};
}
