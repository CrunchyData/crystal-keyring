{
  description = "CrunchyBridge CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-crunchy.url = "github:crunchydata/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-crunchy, flake-utils }:
    let
      systems = builtins.map (a: a.system) (builtins.catAttrs "crystal" (builtins.attrValues nixpkgs-crunchy.outputs.packages));
    in
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        crunchy = nixpkgs-crunchy.packages.${system};

        crystal = crunchy.crystalWrapped.override { buildInputs = [ pkgs.libssh2 ]; };
      in
      {

        devShells.default = pkgs.mkShell {
          buildInputs = with crunchy; [
            crystal2nix
            ameba
          ] ++ [ crystal ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            pkgs.darwin.apple_sdk.frameworks.Security
            pkgs.darwin.apple_sdk.frameworks.Foundation
          ];
        };

      }
    );
}
