{ self, inputs, ... }:
{
  # System Definition
  flake.nixosConfigurations.deck = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      # Hardware Configuration
      ./_hardware-configuration.nix

      # Flake Input modules
      inputs.jovian.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.steam-config-nix.nixosModules.default

      # Users
      self.modules.nixos."users/brandon"

      # User Modules
      deck-core
    ];
  };

  flake.modules.nixos.deck-core = { lib, ... }: {
    imports = with self.modules.nixos; [ core ];

    # System Version
    system.stateVersion = "26.11";

    # User Definition
    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        deck-core
        terminal
        gui
      ];
    };
    users.users.brandon = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "rkit"
      ];
    };

    # Nix settings
    nixpkgs.config.allowUnfree = true;
    nix.settings.trusted-users = [
      "@wheel"
    ];

    # Display
    services.displayManager.noctalia-greeter.enable = lib.mkForce false;

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Deck Config
    jovian.devices.steamdeck.enable = true;
    jovian.hardware = {
      has.amd.gpu = true;
      amd.gpu.enableBacklightControl = true;
    };
    jovian.steam = {
      enable = true;
      autoStart = true;
      user = "brandon";
      desktopSession = "sway";
    };
    jovian.decky-loader = {
      enable = true;
    };

    # Networking
    networking.hostName = "deck";
    networking.networkmanager.enable = true;

    # Services
    services.openssh.enable = true;
  };

  flake.modules.homeManager.deck-core = {
    # Home State Version
    home.stateVersion = "26.05";
  };
}
