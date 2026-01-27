{pkgs, ...}: {
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "perun";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/remotebuilder";
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = ["nixos-test" "big-parallel" "kvm"];
    }
  ];
}
