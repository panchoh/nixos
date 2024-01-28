{
  config,
  attrs ? null,
  ...
}: {
  config.home.stateVersion = attrs.stateVersion;
}
