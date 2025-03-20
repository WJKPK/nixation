{ ... }: {
  users.users.remotebuild = {
    isNormalUser = true;
    createHome = false;
    group = "remotebuild";

    openssh.authorizedKeys.keyFiles = [ ./veles_remotebuilder.pub ./remotebuilder.pub ];
  };

  users.groups.remotebuild = {};

  nix.settings.trusted-users = [ "remotebuild" ];
}
