{
  config,
  attrs ? null,
  ...
}: {
  config.system.stateVersion = attrs.stateVersion;
}
