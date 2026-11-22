{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings.user = {
        email = "brandon@masterofcubesau.com";
        name = "MasterOfCubesAU";
      };
    };

  };
}
