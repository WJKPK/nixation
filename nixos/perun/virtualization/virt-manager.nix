{ pkgs, ... }: 
let 
    hugepage_handler = pkgs.writeShellScript "hp_handler.sh" ''
      xml_file="/var/lib/libvirt/qemu/$1.xml"
      
      function extract_number() {
          local xml_file=$1
          local number=$(grep -oPm1 "(?<=<memory unit='KiB'>)[^<]+" $xml_file)
          echo $((number/1024))
      }
      
      function prepare() { 
          # Calculate number of hugepages to allocate from memory (in MB)
          HUGEPAGES="$(($1/$(($(grep Hugepagesize /proc/meminfo | ${pkgs.gawk}/bin/gawk '{print $2}')/1024))))"
      
          echo "Allocating hugepages..."
          echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
          ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
      
          TRIES=0
          while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
          do
              echo 1 > /proc/sys/vm/compact_memory
              ## defrag ram
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
 in
 {
  virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
#        ovmf = {
#          enable = true;
#          packages = with pkgs; [ OVMFFull.fd ];
#        };
      };
      hooks.qemu = {
        hugepages_handler = "${hugepage_handler}";
      };
  };
  programs.dconf = {
    enable = true; # virt-manager requires dconf to remember settings
  };
  environment.systemPackages = with pkgs; [
    virt-manager
    spice-gtk
    spice-vdagent
    libhugetlbfs
    swtpm
    OVMFFull.fd
  ];
  virtualisation.spiceUSBRedirection.enable = true;
}

