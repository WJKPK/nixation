{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.perun.remoteBuild;
in {
  options.perun.remoteBuild = {
    enable = mkEnableOption "Enable remote build user";
    userName = mkOption {
      type = types.str;
      default = "remotebuild";
    };
    groupName = mkOption {
      type = types.str;
      default = "remotebuild";
    };
    authorizedKeyFiles = mkOption {
      type = types.listOf types.path;
      default = [
        ./veles_remotebuilder.pub
        ./rod_remotebuilder.pub
      ];
      description = "Public keys allowed to build remotely.";
    };
    trustedUsers = mkOption {
      type = types.listOf types.str;
      default = ["remotebuild"];
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      createHome = false;
      group = cfg.groupName;
      openssh.authorizedKeys.keyFiles = cfg.authorizedKeyFiles;
    };

    users.groups.${cfg.groupName} = {};
    nix.settings.trusted-users = cfg.trustedUsers;
  };
}
