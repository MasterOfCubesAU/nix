{ self, ... }:
{
  flake.modules.homeManager.terminal = {
    imports = with self.modules.homeManager; [
      alacritty
      fzf
      nvim
      zsh
    ];
  };
}
