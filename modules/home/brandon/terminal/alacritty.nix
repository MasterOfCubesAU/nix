{
  flake.modules.homeManager.alacritty =
    { pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal.shell.program = "${pkgs.zsh}/bin/zsh";
        };
      };
    };
}
