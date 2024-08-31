{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.firefox;
in {
  options.traits.hm.firefox = {
    enable = lib.mkEnableOption "Firefox" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };

    # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
    # https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/desktop/common/firefox.nix
    # https://gitlab.com/usmcamp0811/dotfiles/-/blob/nixos/modules/home/apps/firefox/default.nix?ref_type=heads
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        containersForce = true;
      };
      policies = {
        # https://mozilla.github.io/policy-templates
        # about:policies#documentation
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;
        DisableAccounts = true;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableSetDesktopBackground = true;
        DisableSystemAddonUpdate = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        DNSOverHTTPS.Enabled = 0;
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Homepage.StartPage = "none";
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLoginsDefault = false;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PasswordManagerEnabled = false;
        SearchBar = "unified"; # alternative: "separate"
        SecurityDevices = {
          Add = {
            "YubiKey/SmartCard" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
          };
        };
        Preferences = let
          lock-true = {
            Value = true;
            Status = "locked";
          };
          lock-false = {
            Value = false;
            Status = "locked";
          };
          lock-strict = {
            Value = "strict";
            Status = "locked";
          };
        in {
          "browser.display.use_document_fonts" = 1; # Force stylix fonts on all pages
          "browser.sessionstore.resume_from_crash" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "browser.contentblocking.category" = lock-strict;
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
      };
    };
  };
}
