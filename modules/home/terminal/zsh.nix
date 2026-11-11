{
  flake.modules.homeManager.zsh = {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      initContent = "source ${../dotfiles/zshrc/cse}";
      shellAliases = {
        k = "kubectl";
        kn = "kubens";
        ns = "nix search nixpkgs";
        nsh = "nix-shell -p";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "fzf"
        ];
        theme = "philips";
      };
    };
  };
}
