{
  flake.modules.homeManager.fzf =
    { pkgs, ... }:
    {
      programs.fzf.enableZshIntegration = true;
      home.packages = with pkgs; [ fzf ];
    };
}
