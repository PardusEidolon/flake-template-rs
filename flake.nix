{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = 
    { self
    , nixpkgs
    , flake-utils
    , rust-overlay
    , ... } 
    @inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };
        rustTools = with pkgs; rust-bin.stable.latest.default.override {
          extensions = ["rust-analyzer" "rust-src" "rust-std" "rust-docs"];
        };
      in 
        { 
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              rustTools 
              libiconv
              lsd
              mktemp
            ];
          };
        }
    );
}
