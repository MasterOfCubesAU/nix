{
  flake.modules.homeManager.noctalia = {
    home.file.".config/noctalia/config.toml".source = ../dotfiles/noctalia/nocatalia.toml;
  };
}
