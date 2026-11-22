{
  flake.modules.homeManager.sway = { pkgs, lib, ... }: {
    home.file.".config/sway/config".source = ../dotfiles/sway/config;
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      with pkgs;
      [
        ycwd
        wl-clipboard
        autotiling
      ]
    );
  };
}
