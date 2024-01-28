{
  config,
  lib,
  ...
}: let
  cfg = config.traits.chrome;
in {
  imports = [./chrome.nix];

  options.traits.chrome = {
    enable = lib.mkEnableOption "chrome" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.chrome = {
      # Seen on stylix and nixpkgs:
      # This enables policies without installing the browser. Policies take up a
      # negligible amount of space, so it's reasonable to have this always on.
      # https://chromeenterprise.google/policies/
      enable = true;
      extraOpts = {
        "AutofillAddressEnabled" = false;
        "AutofillCreditCardEnabled" = false;
        "BackgroundModeEnabled" = false;
        "BlockExternalExtensions" = true;
        "BrowserAddPersonEnabled" = false;
        "BrowserLabsEnabled" = false;
        "BrowserSignin" = 2;
        # "BrowserThemeColor" = "#282936";
        # "DnsOverHttpsMode" = "secure";
        "EnableMediaRouter" = false;
        "HideWebStoreIcon" = true;
        "IncognitoModeAvailability" = 1;
        "OsColorMode" = "dark";
        "PasswordManagerEnabled" = false;
        "PromptForDownloadLocation" = false;
        "ShowAppsShortcutInBookmarkBar" = false;
        "SpellcheckEnabled" = false;
        "SpellcheckLanguage" = ["en-US"];
        "SpellCheckServiceEnabled" = false;
        "ShowCastIconInToolbar" = false;
        "SyncDisabled" = false;
      };
    };
  };
}
