{
  description = "polarmutex NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # crane.url = "github:ipetkov/crane";
    # crane.inputs.nixpkgs.follows = "nixpkgs";

    # awesomewm
    awesome-git-src = {
      url = "github:awesomeWM/awesome";
      flake = false;
    };
    awesome-battery-widget-git = {
      url = "github:Aire-One/awesome-battery_widget";
      flake = false;
    };
    bling-git = {
      url = "github:BlingCorp/bling";
      flake = false;
    };
    rubato-git = {
      url = "github:andOrlando/rubato";
      flake = false;
    };

    # beancount
    # beancount-langserver-git = {
    #   url = "github:polarmutex/beancount-language-server";
    # };
    # beangrow-git = { url = "github:beancount/beangrow"; flake = false; };

    # wezterm-git-src = {
    #   type = "git";
    #   url = "https://github.com/wez/wezterm.git";
    #   ref = "main";
    #   submodules = true;
    #   flake = false;
    # };

    # about picom forks
    # https://nuxsh.is-a.dev/blog/picom.html
    # picom-git-src = {
    #   type = "git";
    #   url = "https://github.com/yshui/picom.git";
    #   ref = "next";
    #   flake = false;
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    systems = [
      "x86_64-linux"
      # "i686-linux"
      # "x86_64-darwin"
      # "aarch64-linux"
      # "armv6l-linux"
      # "armv7l-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    packages = forAllSystems (system:
      import ./default.nix {
        pkgs = import nixpkgs {
          inherit system;
          allowBroken = false;
          allowUnfree = false;
          overlays = [
            (import inputs.rust-overlay)
          ];
          config = {
            permittedInsecurePackages = [
            ];
            allowUnsupportedSystem = false;
          };
        };
      });
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in
      import ./shell.nix {inherit pkgs;});
  };
}
