{ self, inputs, ... }:
{
  # System Definition
  flake.darwinConfigurations.Brandons-MacBook-Pro = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = with self.modules.darwin; [
      # Flake Input Modules
      inputs.mac-app-util.darwinModules.default
      inputs.home-manager.darwinModules.home-manager

      # Users
      self.modules.darwin."users/brandon"

      # User Modules
      Brandons-MacBook-Pro-core
    ];
  };

  flake.modules.darwin.Brandons-MacBook-Pro-core = {
    imports = with self.modules.darwin; [ core ];

    # System Definition
    system = {
      stateVersion = 5;
      primaryUser = "brandon";
    };
  };

  flake.modules.homeManager.Brandons-MacBook-Pro-core = {
    # Home State Version
    home.stateVersion = "25.05";
  };
}
