{
  description = "Diff and stage hunks by regex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
  }: let
    forEachSystem = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  in {
    devShells = forEachSystem (system: let
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
          };
        };
      };
    in {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        inherit (checks.pre-commit-check) shellHook;
      };
    });

    packages = forEachSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      name = "git-diff-regex";
      scriptBuildInputs = with pkgs; [git patchutils];
      script = (pkgs.writeScriptBin name (builtins.readFile ./git-diff-regex.sh)).overrideAttrs (old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in {
      default = pkgs.symlinkJoin {
        inherit name;
        paths = [script] ++ scriptBuildInputs;
        buildInputs = [pkgs.makeWrapper];
        postBuild = "wrapProgram $out/bin/${name}";
      };
    });
  };
}
