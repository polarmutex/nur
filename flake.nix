{
  description = "polarmutex NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";

    # awesomewm
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

    # beancount
    beancount-langserver-git = {
      url = "github:polarmutex/beancount-language-server";
    };
    beangrow-git = { url = "github:beancount/beangrow"; flake = false; };

    # neovim
    neovim = {
      url = "github:neovim/neovim?dir=contrib&tag=master";
    };
    neovim-flake = {
      url = "github:polarmutex/neovim-flake";
    };

    wezterm-git-src = {
      type = "git";
      url = "https://github.com/wez/wezterm.git";
      ref = "main";
      submodules = true;
      flake = false;
    };

    # about picom forks
    # https://nuxsh.is-a.dev/blog/picom.html
    picom-git-src = {
      type = "git";
      url = "https://github.com/yshui/picom.git";
      ref = "next";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let

          pkgs = import nixpkgs {
            inherit system;
            allowBroken = true;
            allowUnfree = true;
            overlays = [
              inputs.neovim.overlay
              inputs.neovim-flake.overlays.default
            ];
            config = {
              permittedInsecurePackages = [
                # jdt-language-server
                "openjdk-headless-16+36"
                "openjdk-headless-15.0.1-ga"
                "openjdk-headless-14.0.2-ga"
                "openjdk-headless-13.0.2-ga"
                "openjdk-headless-12.0.2-ga"
              ];
              # jdt-language-server
              allowUnsupportedSystem = true;
            };
          };

          nurPkgs = import ./pkgs (pkgs // nurPkgs) pkgs inputs;
          #nurAttrs = import ./pkgs { inherit inputs; };
          #nurPkgs = (import ./pkgs (pkgs // nurPkgs) pkgs) { inherit inputs; };

        in
        rec {
          #checks = packages;
          packages = flake-utils.lib.filterPackages system (flake-utils.lib.flattenTree nurPkgs);
        }
      ) // rec {
      overlays.default = final: prev:
        let
          nurPkgs = removeAttrs (import ./pkgs final prev inputs) [ "callPackage" ];

          pythonOverrides = pyfinal: pyprev:
            removeAttrs (import ./pkgs/python-modules final pyfinal pyprev) [ "callPackage" ];
        in
        nurPkgs // {
          python3 = prev.python3.override { packageOverrides = pythonOverrides; };
          python38 = prev.python38.override { packageOverrides = pythonOverrides; };
          python39 = prev.python39.override { packageOverrides = pythonOverrides; };
          python310 = prev.python310.override { packageOverrides = pythonOverrides; };
          python3Packages = final.python3.pkgs;
          python38Packages = final.python38.pkgs;
          python39Packages = final.python39.pkgs;
          python310Packages = final.python310.pkgs;
        };
      #nixosModules = nixpkgs.lib.mapAttrs (name: value: import value) (import ./modules);
    };
}
