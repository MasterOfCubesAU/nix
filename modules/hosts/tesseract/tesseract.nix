{ self, inputs, ... }:
{
  # System Definition
  flake.nixosConfigurations.tesseract = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      # Hardware Configuration
      ./_hardware-configuration.nix

      # Flake Input Modules
      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-rocksmith.nixosModules.default
      inputs.steam-config-nix.nixosModules.default

      # Users
      self.modules.nixos."users/brandon"

      # User Modules
      tesseract-core
      lumix-tether
      gaming
    ];
  };

  flake.modules.nixos.tesseract-core = {
    imports = with self.modules.nixos; [
      core
      nvidia
    ];

    # System Version
    system.stateVersion = "26.05";

    # User Definition
    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        tesseract-core
        gui
      ];
    };

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.hostName = "tesseract";

    # Greeter
    services.displayManager.noctalia-greeter = {
      settings = {
        output = {
          name = "Acer Technologies XV345CUR V3 2439024892X00";
        };
      };
    };
  };

  flake.modules.homeManager.tesseract-core = {
    # Dotfiles
    home.file.".config/kanshi/config".source = ./dotfiles/kanshi.config;
    home.file.".config/sway/config.d/tesseract".source = ./dotfiles/sway.config;
  };
}
