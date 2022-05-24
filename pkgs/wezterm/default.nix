{ dbus
, egl-wayland
, fontconfig
, freetype
, lib
, libGL
, libGLU
, libglvnd
, libX11
, libxcb
, libxkbcommon
, naersk-lib
, ncurses
, openssl
, perl
, pkg-config
, python3
, rustPlatform
, src
, version
, wayland
, xcbutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilwm
, zlib
, stdenv
  #, Cocoa
  #, CoreGraphics
  #, Foundation
  #, libiconv
}:

let
  runtimeDeps = [
    dbus
    freetype
    fontconfig
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    egl-wayland
    libglvnd
    libGL
    libGLU
    libX11
    libxcb
    libxkbcommon
    openssl
    wayland
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm
  ] ++ lib.optionals stdenv.isDarwin [
    #Cocoa
    #CoreGraphics
    #Foundation
    #libiconv
  ];

in
naersk-lib.buildPackage {
  pname = "wezterm-git";

  inherit version;
  inherit src;

  nativeBuildInputs = [
    pkg-config
    python3
    ncurses
  ] ++ lib.optional stdenv.isDarwin perl;

  buildInputs = runtimeDeps;

  preFixup = lib.optionalString stdenv.isLinux ''
    for artifact in wezterm wezterm-gui wezterm-mux-server strip-ansi-escapes; do
      patchelf --set-rpath "${
        lib.makeLibraryPath runtimeDeps
      }" $out/bin/$artifact
    done
  '';

  singleStep = true;

  gitAllRefs = true;
  gitSubmodules = true;

  doCheck = false;
  dontPatchELF = true;

  meta = with lib; {
    description =
      "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ javacafe01 ];
  };
}

