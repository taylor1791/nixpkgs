{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, stdenv
, Security
, zig
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lambda";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-un+GQflxhMHCMH5UEeUVsYx59ryn7MR4ApooeOuhccc=";
  };

  cargoSha256 = "sha256-p3q5S6IFQQgNp/MHGSUE1DVLFyMLWDTv/dxrUACKSWo=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  checkFlags = [
    # Disabled because it accesses the network.
    "--skip=test_download_example"
  ];

  # remove date from version output to make reproducible
  postPatch = ''
    rm crates/cargo-lambda-cli/build.rs
  '';

  postInstall = ''
    wrapProgram $out/bin/cargo-lambda --prefix PATH : ${lib.makeBinPath [ zig ]}
  '';

  CARGO_LAMBDA_BUILD_INFO = "(nixpkgs)";

  meta = with lib; {
    description = "A Cargo subcommand to help you work with AWS Lambda";
    homepage = "https://cargo-lambda.info";
    license = licenses.mit;
    maintainers = with maintainers; [ taylor1791 calavera ];
  };
}
