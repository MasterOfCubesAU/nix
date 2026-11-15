{
  flake.modules.nixos.steam = {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
}
