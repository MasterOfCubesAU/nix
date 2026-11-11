{ self, inputs, ... }:
{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.modules.nixos; [
      inputs.nixos-wsl.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      wsl-users
      wsl-networking
      self.modules.generic.core
      {
        wsl = {
          enable = true;
          defaultUser = "brandon";
          ssh-agent.enable = true;
        };
        system.stateVersion = "25.05";
        programs.zsh.enable = true;
      }
    ];
  };

  flake.modules.nixos.wsl-users = { pkgs, ... }: {
    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        programming
        terminal
        tooling
      ];
      home.stateVersion = "25.05";
    };
    users.users.brandon = {
      isNormalUser = true;
      shell = pkgs.zsh;
      initialPassword = "password";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  flake.modules.nixos.wsl-networking = {
    networking.hostName = "wsl";
  };
}
