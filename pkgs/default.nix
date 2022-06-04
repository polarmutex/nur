final: prev: inputs:

with final;

let
  callPackage = pkgs.newScope final;
  naersk = inputs.naersk.lib."${system}";
  pythonOverrides = import ./python-modules final;
in
{
  inherit callPackage;

  python3Packages = recurseIntoAttrs (pythonOverrides (pkgs.python3Packages // python3Packages) pkgs.python3Packages);

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

  awesome-battery-widget-git = callPackage ./awesome-battery-widget {
    src = inputs.awesome-battery-widget-git;
    inherit (pkgs.lua52Packages) lua toLuaModule;
  };
  bling-git = callPackage ./bling {
    src = inputs.bling-git;
    inherit (pkgs.lua52Packages) lua toLuaModule;
  };
  rubato-git = callPackage ./rubato {
    src = inputs.rubato-git;
    inherit (pkgs.lua52Packages) lua toLuaModule;
  };


  neovim-git = pkgs.neovim;

  wezterm-git = callPackage ./wezterm {
    version = "nightly";
    naersk-lib = naersk;
    src = inputs.wezterm-git-src;
  };

  # beancount and fava
  beancount-language-server-git = inputs.beancount-langserver-git.packages."${system}".beancount-language-server-git;
}
