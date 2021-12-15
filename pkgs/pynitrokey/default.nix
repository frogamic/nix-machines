{ python3Packages, lib, fetchurl }:

with python3Packages;

let
	nkdfu = buildPythonPackage rec {
		pname = "nkdfu";
		version = "0.1";
		src = fetchPypi {
			inherit pname version;
			sha256 = "sha256-Y8GonfCBi3BNMhZ99SN6/SDSa0+dbfPIMPoVzALwH5A=";
		};

		format = "flit";
		propagatedBuildInputs = [
			fire
			tqdm
			intelhex
			libusb1
		];
	};
in

buildPythonApplication rec {
	pname = "pynitrokey";
	version = "0.4.9";

	src = fetchPypi {
		inherit pname version;
		sha256 = "sha256-mhH6mVgLRX87PSGTFkj1TE75jU1lwcaRZWbC67T+vWo=";
	};

	doCheck = false;

	format = "flit";
	propagatedBuildInputs = [
		click
		cryptography
		ecdsa
		fido2
		intelhex
		pyserial
		pyusb
		requests
		pygments
		python-dateutil
		urllib3
		cffi
		cbor
		nkdfu
	];

	meta = with lib; {
		description = "Python client for Nitrokey devices";
		homepage = "https://github.com/Nitrokey/pynitrokey";
		license=licenses.asl20;
		maintainers = with maintainers; [ frogamic ];
	};
}
