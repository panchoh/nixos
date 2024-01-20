{
  config,
  lib,
  attrs ? null,
  ...
}: {
  options.traits.font = {
    terminal = lib.mkOption {
      type = lib.types.int;
      default = 14;
    };

    applications = lib.mkOption {
      type = lib.types.int;
      default = 12;
    };
  };

  config.traits.font = lib.mkIf attrs.isLaptop or false {
    terminal = 12;
    applications = 10;
  };
}
