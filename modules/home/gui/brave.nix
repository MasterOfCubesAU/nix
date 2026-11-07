{
  flake.modules.homeManager.brave = { pkgs, ... }: {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      ];
    };
  };
}
