{ moduleWithSystem, ... }:
{
  flake.modules.homeManager.nvim = moduleWithSystem (
    { self', ... }:
    {
      home.sessionVariables.EDITOR = "nvim";
      home.packages = [ self'.packages.nvim ];
    }
  );

}
