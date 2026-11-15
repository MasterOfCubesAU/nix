{ self, inputs, ... }:
let
  username = "brandon";
in
{
  # System Definition
  flake.darwinConfigurations.Brandons-MacBook-Pro = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = with self.modules.darwin; [
      inputs.mac-app-util.darwinModules.default
      inputs.home-manager.darwinModules.home-manager
      Brandons-MacBook-Pro-core
    ];
  };

  flake.modules.darwin.Brandons-MacBook-Pro-core = {
    imports = with self.modules.darwin; [ core ];

    # System Version
    system.stateVersion = 5;

    # User Definition
    system.primaryUser = username;
    home-manager.users."${username}" = {
      imports = with self.modules.homeManager; [
        inputs.mac-app-util.homeManagerModules.default
        Brandons-MacBook-Pro-core
        programming
        terminal
        tooling
        gui
      ];
    };
    users.users."${username}" = {
      name = username;
      home = "/Users/${username}";
    };
  };

  flake.modules.homeManager.Brandons-MacBook-Pro-core = {
    # Home State Version
    home.stateVersion = "25.05";
  };
}
