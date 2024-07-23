{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.sound;
in {
  options.traits.sound = {
    enable = lib.mkEnableOption "sound" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    users.users.${box.userName or "alice"}.extraGroups = ["audio"];
    security.rtkit.enable = true;
    services.pipewire.enable = true;
    services.pipewire.pulse.enable = true;
  };
}
