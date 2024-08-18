{
  config,
  box ? null,
  ...
}: {
  config.system.stateVersion = box.stateVersion;
}
