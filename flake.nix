{
  description = "Diff and stage hunks by regex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forEachSystem = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  in {
    packages = forEachSystem (system: {
      default = nixpkgs.legacyPackages.${system}.writeShellApplication {
        name = "git-diff-regex";
        runtimeInputs = with nixpkgs.legacyPackages.${system}; [git patchutils];
        text = builtins.readFile ./git-diff-regex.sh;
      };
    });
  };
}
