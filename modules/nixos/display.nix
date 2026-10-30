{ inputs, ... }:
{
  flake.modules.nixos.display = {
    imports = [ inputs.noctalia.nixosModules.default ];
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
  };
}
