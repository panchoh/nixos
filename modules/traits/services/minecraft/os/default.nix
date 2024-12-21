{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.os.minecraft;
in {
  options.traits.os.minecraft = {
    enable = lib.mkEnableOption "Minecraft Server" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
      declarative = true;
      whitelist = {
        # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
        username1 = "b08a8658-e560-47ba-8a22-c23bc9caca35";
        username2 = "fcac3618-4e0a-490d-9c0b-b77de41bda0e";
      };
      serverProperties = {
        server-port = 25565;
        difficulty = 3;
        gamemode = 0;
        force-gamemode = true;
        max-players = 5;
        motd = "NixOS Minecraft server!";
        white-list = true;
        allow-cheats = true;
      };
      jvmOpts = "-Xms8192M -Xmx8192M -XX:+UseG1GC -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -Djava.net.preferIPv4Stack=true";
    };
  };
}
