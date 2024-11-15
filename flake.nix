{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Determine the moss script URL based on multiple options
        mossScriptUrl = if builtins.getEnv "MOSS_SCRIPT_URL" != "" then
          builtins.getEnv "MOSS_SCRIPT_URL"
        else if self ? mossUrl then
          self.mossUrl
        else
          builtins.trace "Error: No valid MOSS script URL provided. Please set MOSS_SCRIPT_URL or provide a flake input." (throw "No MOSS script URL provided. Build failed.");
      in {
        # Define the moss package as a default package for easier building
        defaultPackage = pkgs.stdenv.mkDerivation {
          pname = "moss";
          version = "0.0.1";

          # Fetch the mossnet Perl script using the determined URL
          src = pkgs.fetchurl {
            url = mossScriptUrl;
            # Keep placeholder sha256; should be replaced if the real script URL is used
            sha256 = "sha256-FDoWMIIafl93c6orFYbESgR2j8DXzv/3ZddzFPLY3Ns=";
          };

          # Disable unpackPhase because it's a raw text Perl script
          dontUnpack = true;

          nativeBuildInputs = [ pkgs.perl ];

          installPhase = ''
            # Create the output directory for the moss script
            mkdir -p $out/bin
            # Copy the mossnet script and rename it to moss for easier usage
            cp $src $out/bin/moss
            chmod +x $out/bin/moss
          '';

          meta = with pkgs.lib; {
            description = "MOSS plagiarism detection script";
            license = licenses.unfreeRedistributable; # Not freely licensed
            maintainers = [ maintainers.jakob1379 ];
            platforms = platforms.all;
          };
        };

        # Optional: keep moss available as an explicit package reference
        packages.moss = self.defaultPackage;
      });
}
