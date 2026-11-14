{ self, inputs, ... }:
{
  # System Definition
  flake.nixosConfigurations.tesseract = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      ./_hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-rocksmith.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      tesseract-users
      tesseract-bootloader
      tesseract-networking
      tesseract-graphics
      tesseract-sops
      lumix-tether
      core
      {
        system.stateVersion = "26.05";
        home-manager.sharedModules = [ inputs.steam-config-nix.homeModules.default ];
        programs.steam = {
          enable = true;
          gamescopeSession.enable = true;
          rocksmithPatch.enable = true;
        };
      }
      ({ config, ... }: {
        fileSystems."/mnt/brandon" = {
          device = "//192.168.1.178/Brandon";
          fsType = "cifs";
          options = [
            "credentials=${config.sops.templates."smb/brandon".path}"
            "uid=1000"
            "gid=100"
            "x-systemd.automount"
            "noauto"
            "_netdev"
          ];
        };
      })
    ];
  };

  flake.modules.nixos.tesseract-users = {
    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        gui
        programming
        terminal
        tooling
        tesseract-configs
      ];
      home.stateVersion = "26.05";
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
  };

  flake.modules.nixos.tesseract-bootloader = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };

  flake.modules.nixos.tesseract-networking = {
    networking.hostName = "tesseract";
  };

  flake.modules.nixos.tesseract-graphics =
    { config, ... }:
    {
      hardware.graphics = {
        enable = true;
      };
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
      services.displayManager.noctalia-greeter = {
        settings = {
          output = {
            name = "Acer Technologies XV345CUR V3 2439024892X00";
          };
        };
      };
    };

  flake.modules.homeManager.tesseract-configs = {
    home.file.".config/kanshi/config".source = ./kanshi.config;
    home.file.".config/sway/config.d/tesseract".source = ./sway.config;
    home.file.".config/yazi/keymap.toml".source = ./yazi-keymap.toml;
  };

  flake.modules.nixos.tesseract-sops = { config, ... }: {
    sops = {
      age.keyFile = "/home/brandon/.config/sops/age/keys.txt";
      defaultSopsFile = ../../../secrets.yaml;
      secrets = {
        "smb/brandon" = { };
      };
      templates = {
        "smb/brandon".content = ''
          username=brandon
          password=${config.sops.placeholder."smb/brandon"}
        '';

      };
    };
  };
}
