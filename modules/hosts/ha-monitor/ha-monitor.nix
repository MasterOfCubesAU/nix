{ self, inputs, ... }:
{
  # System Definition
  flake.nixosConfigurations.ha-monitor = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      # Hardware Configuration
      # ./_hardware-configuration.nix

      # User Modules
      ha-monitor-core
    ];
  };

  flake.modules.nixos.ha-monitor-core = { pkgs, lib, ... }: {
    imports = with self.modules.nixos; [
      core
    ];

    services.displayManager.noctalia-greeter.enable = lib.mkForce false;
    # System Version
    system.stateVersion = "26.05";

    programs.firefox = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisableDeveloperTools = true;
        DisableFirefoxAccounts = true;
        DisablePrivateBrowsing = true;
        OverrideFirstRunPage = "";
        NoDefaultBookmarks = true;
      };
    };

    services.cage = {
      enable = true;
      user = "home";
      program = "${pkgs.firefox}/bin/firefox --kiosk 192.168.1.252:8123";
    };

    users.users.home = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [
        "networkmanager"
      ];
    };

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.hostName = "ha-monitor";
  };
}
