{
  flake.modules.homeManager.sway = { pkgs, lib, ... }: {
    home.file.".config/sway/config".source = ../dotfiles/sway/config;
    home.file.".config/sway/alternating-layouts.py".source =
      let
        alternatingLayoutsDeriv = pkgs.stdenv.mkDerivation {
          name = "alternating-layouts";
          propagatedBuildInputs = [ (pkgs.python312.withPackages (ppkgs: [ ppkgs.i3ipc ])) ];
          dontUnpack = true;
          installPhase = "install -Dm755 ${../dotfiles/sway/alternating-layouts.py} $out/bin/alternating-layouts";
        };
      in
      "${alternatingLayoutsDeriv}/bin/alternating-layouts";
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      with pkgs;
      [
        ycwd
        wl-clipboard
      ]
    );
  };
}
