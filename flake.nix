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
    awesome-battery-widget-git = {
      url = "github:Aire-One/awesome-battery_widget";
      flake = false;
    };
    bling-git = { url = "github:BlingCorp/bling"; flake = false; };
    rubato-git = { url = "github:andOrlando/rubato"; flake = false; };

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
      overlays.default = final: prev: {
        inherit (self.packages.${final.system})
          awesome-git
          awesome-battery-widget-git
          bling-git
          rubato-git

          beancount-language-server-git

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
            patches = [ ];

            GI_TYPELIB_PATH = "${pkgs.playerctl}/lib/girepository-1.0:"
            + "${pkgs.upower}/lib/girepository-1.0:"
            + "${pkgs.networkmanager}/lib/girepository-1.0:"
            + old.GI_TYPELIB_PATH;
          })).override {
            gtk3Support = true;
          };
          awesome-battery-widget-git = pkgs.callPackage ./pkgs/awesome-battery-widget {
            src = inputs.awesome-battery-widget-git;
            inherit (pkgs.lua52Packages) lua toLuaModule;
          };
          bling-git = pkgs.callPackage ./pkgs/bling {
            src = inputs.bling-git;
            inherit (pkgs.lua52Packages) lua toLuaModule;
          };
          rubato-git = pkgs.callPackage ./pkgs/rubato {
            src = inputs.rubato-git;
            inherit (pkgs.lua52Packages) lua toLuaModule;
          };

          beancount-language-server-git = inputs.beancount-langserver.packages."${system}".beancount-language-server-git;


          neovim-git = pkgs.neovim;

          wezterm-git = pkgs.callPackage ./pkgs/wezterm {
            version = "nightly";
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
