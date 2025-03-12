{ pkgs, ...}: {
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf.override {
      nativeMessagingHosts = with pkgs; [
        keepassxc
      ];
    };
    policies = {
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      FirefoxHome = { Pocket = false; Snippets = false; };
      OfferToSaveLogins = false;
      UserMessaging = { SkipOnboarding = true; ExtensionRecommendations = false; };
    };
    profiles.default = {
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          darkreader
          don-t-fuck-with-paste
          keepassxc-browser
          ublock-origin
          unpaywall
          vimium-c
          youtube-shorts-block
          return-youtube-dislikes
          youtube-recommended-videos
        ];
        search.default = "https://duckduckgo.com";
        search.privateDefault = "https://duckduckgo.com";
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.contentblocking.category" = "custom";
          "browser.newtabpage.enabled" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.startup.page" = 3;
          "dom.security.https_only_mode" = true;
          "network.cookie.cookieBehavior" = 1;
          "privacy.annotate_channels.strict_list.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "security.identityblock.show_extended_validation" = true;
        };
      };
  };
}

