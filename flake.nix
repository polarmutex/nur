{
  description = "polarmutex NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";

    awesome-git-src = {
      url = "github:awesomeWM/awesome";
      flake = false;
    };

    beancount-langserver = {
      url = "github:polarmutex/beancount-language-server";
    };

    neovim = {
      url = "github:neovim/neovim?dir=contrib&tag=master";
    };

    wezterm-git-src = {
      type = "git";
      url = "https://github.com/wez/wezterm.git";
      ref = "main";
      submodules = true;
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, ... }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system})
          awesome-git
          neovim-git
          wezterm-git;
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (builtins) elem;
        inherit (nixpkgs) lib;
        inherit (lib) all filterAttrs;

        naersk = inputs.naersk.lib."${system}";

        pkgs = import nixpkgs {
          inherit system;
          allowBroken = true;
          allowUnfree = true;
          overlays = [
            inputs.neovim.overlay
          ];
        };

        packages_prime = rec {
          awesome-git = (pkgs.awesome.overrideAttrs (old: rec {
            version = "master";
            src = inputs.awesome-git-src;

            GI_TYPELIB_PATH = "${pkgs.playerctl}/lib/girepository-1.0:"
            + "${pkgs.upower}/lib/girepository-1.0:"
            + "${pkgs.networkmanager}/lib/girepository-1.0:"
            + old.GI_TYPELIB_PATH;
          })).override {
            gtk3Support = true;
          };

          beancount-language-server-git = inputs.beancount-langserver.packages."${system}".beancount-language-server-git;

          neovim-git = pkgs.neovim;

          wezterm-git = pkgs.callPackage ./pkgs/wezterm {
            version = "master";
            naersk-lib = naersk;
            src = inputs.wezterm-git-src;
          };
        };

      in
      {
        packages = flake-utils.lib.filterPackages system packages_prime;
      }
    );

}
