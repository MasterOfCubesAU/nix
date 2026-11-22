{ self, inputs, ... }:

{
  # System Definition
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.modules.nixos; [
      # Flake Input Modules
      inputs.nixos-wsl.nixosModules.default
      inputs.home-manager.nixosModules.home-manager

      # User Modules
      wsl-core
    ];
  };

  flake.modules.nixos.wsl-core = {
    imports = with self.modules.nixos; [ core ];

    # Networking
    networking.hostName = "wsl";

    # WSL
    wsl = {
      enable = true;
      defaultUser = "brandon";
      ssh-agent.enable = true;
    };

    system.stateVersion = "25.05";
  };
}
