# Polarmutex NUR packages

[![Build and populate cache](https://github.com/polarmutex/nur/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/polarmutex/nur/actions/workflows/build.yml)
[![Update Flake](https://github.com/polarmutex/nur/actions/workflows/update-flake.yml/badge.svg)](https://github.com/polarmutex/nur/actions/workflows/update-flake.yml)
[![Cachix Cache](https://img.shields.io/badge/cachix-polarmutex-blue.svg)](https://polarmutex.cachix.org)

**My personal [NUR](https://github.com/nix-community/NUR) repository**

## Packages Provided

### awesome-git

### [beancount-language-server-git](https://github.com/polarmutex/beancount-language-server)

### [bling](https://blingcorp.github.io/bling/#/README)

### neovim-git

### wezterm-git

## Usage

### Flake enabled Nix:

```nix
{
    inputs.polar-nur.url = "github:polarmutex/nur";

    outputs = { self, polar-nur, ... }@inputs: {
        nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                { nixpkgs.overlays = [ polar-nur.overlay ]; }
                ./configuration.nix
            ];
        };
    };
}
```

### Binary Cache

cachix use polarmutex or if you're like me, and is doing it the manual approach

```nix
{
nix.settings.substituters = [
    "https://cache.nixos.org?priority=10"
    "https://polarmutex.cachix.org"
];

nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
];
}
```

```

```
