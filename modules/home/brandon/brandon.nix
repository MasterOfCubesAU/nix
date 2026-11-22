{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos."users/brandon" = { config, pkgs, ... }: {
    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        self.modules.homeManager."users/brandon"
        inputs.sops-nix.homeManagerModules.sops
        inputs.steam-config-nix.homeModules.default

        # User Modules
        programming
        terminal
        tooling
      ];
    };

    users.users.brandon = {
      uid = 1000;
      isNormalUser = true;
      initialPassword = "password";
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "rkit"
      ];
    };

    # ZSH
    programs.zsh.enable = true;

    # Nix Settings
    nix.settings = {
      substituters = [ "https://nixos-rocksmith.cachix.org" ];
      trusted-public-keys = [
        "nixos-rocksmith.cachix.org-1:gg6dJg9svbP30JVrtFwkCpGVBkHbEwYswGS2VoXJ2qo="
      ];
      trusted-users = [
        "@wheel"
      ];
    };

    # SMB
    fileSystems."/mnt/brandon" = {
      device = "//192.168.1.178/Brandon";
      fsType = "cifs";
      options = [
        "credentials=${config.home-manager.users.brandon.sops.templates."smb/brandon".path}"
        "uid=${toString config.users.users.brandon.uid}"
        "x-systemd.automount"
        "noauto"
        "_netdev"
      ];
    };
  };

  flake.modules.darwin."users/brandon" = {
    home-manager.users."brandon" = {
      imports = with self.modules.homeManager; [
        inputs.mac-app-util.homeManagerModules.default
        Brandons-MacBook-Pro-core
        programming
        terminal
        tooling
        gui
      ];
    };
    users.users."brandon" = {
      name = "brandon";
      home = "/Users/brandon";
    };

  };

  flake.modules.homeManager."users/brandon" = { config, ... }: {
    # Home State Version
    home.stateVersion = "26.05";

    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;
      secrets = {
        "smb/brandon" = { };
      };
      templates = {
        "smb/brandon".content = ''
          brandon=brandon
          password=${config.sops.placeholder."smb/brandon"}
        '';
      };
    };
  };
}
