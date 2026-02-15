{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types optionals;
  cfg = config.perun.virtualization.virtManager;
  hugepageHandler = pkgs.writeShellScript "hp_handler.sh" ''
    xml_file="/var/lib/libvirt/qemu/$1.xml"

    function extract_number() {
        local xml_file=$1
        local number=$(grep -oPm1 "(?<=<memory unit='KiB'>)[^<]+" $xml_file)
        echo $((number/1024))
    }

    function prepare() {
        HUGEPAGES="$(($1/$(($(grep Hugepagesize /proc/meminfo | ${pkgs.gawk}/bin/gawk '{print $2}')/1024))))"

        echo "Allocating hugepages..."
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

        TRIES=0
        while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
        do
            echo 1 > /proc/sys/vm/compact_memory
            echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
            ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
            echo "Successfully allocated $ALLOC_PAGES / $HUGEPAGES"
            let TRIES+=1
        done

        if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
        then
            echo "Not able to allocate all hugepages. Reverting..."
            echo 0 > /proc/sys/vm/nr_hugepages
            exit 1
        fi
    }

    function release() {
        echo 0 > /proc/sys/vm/nr_hugepages
    }

    case $2 in
        prepare)
            number=$(extract_number $xml_file)
            prepare $number
            ;;
        release)
            release
            ;;
    esac
  '';
  basePackages = with pkgs; [
    virt-manager
    spice-gtk
    spice-vdagent
    swtpm
    OVMFFull.fd
  ];
  hugepagePackages = with pkgs; [libhugetlbfs];
in {
  options.perun.virtualization.virtManager = {
    enable = mkEnableOption "Enable libvirt stack with virt-manager";
    enableHugepageHook = mkOption {
      type = types.bool;
      default = true;
      description = "Toggle hugepage allocation hook for VMs.";
    };
    qemuPackage = mkOption {
      type = types.package;
      default = pkgs.qemu_kvm;
      description = "QEMU package used by libvirtd.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = cfg.qemuPackage;
        swtpm.enable = true;
      };
      hooks.qemu = lib.optionalAttrs cfg.enableHugepageHook {
        hugepages_handler = "${hugepageHandler}";
      };
    };
    programs.dconf.enable = true;
    environment.systemPackages =
      basePackages
      ++ optionals cfg.enableHugepageHook hugepagePackages;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
