{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.google-chrome;
in
{
  imports = [
    ./google-chrome.nix
  ];

  options.traits.os.google-chrome = {
    enable = lib.mkEnableOption "Google Chrome" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.google-chrome = {
      # Seen on stylix and nixpkgs:
      # This enables policies without installing the browser. Policies take up a
      # negligible amount of space, so it's reasonable to have this always on.
      # https://chromeenterprise.google/policies/
      enable = true;
      extraOpts = {
        "AlwaysOpenPdfExternally" = true; # Force Google Chrome to download PDFs instead of opening them
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
        "SpellcheckLanguage" = [ "en-US" ];
        "SpellCheckServiceEnabled" = false;
        "ShowCastIconInToolbar" = false;
        "SyncDisabled" = false;
      };
    };
  };
}
