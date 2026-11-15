{ self, ... }:
{
  flake.modules.nixos.gaming = {
    imports = with self.modules.nixos; [
      steam
      rocksmith
    ];

    home-manager.users.brandon = {
      imports = with self.modules.homeManager; [
        rocksmith
      ];
    };
  };
}
