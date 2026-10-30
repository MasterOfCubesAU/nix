{
  flake.modules.homeManager.sway = { pkgs, ... }: {
    home.file.".config/sway/config".source = ../dotfiles/sway/config;
    home.file.".config/sway/alternating-layouts.py".source = ../dotfiles/sway/alternating-layouts.py;
  };
}
