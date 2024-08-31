{
  config,
  box ? null,
  ...
}: {
  config.home.stateVersion = box.stateVersion;
}
