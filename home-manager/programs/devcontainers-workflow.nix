{pkgs, ...}:
let
  dni-arise = pkgs.writeShellScriptBin "dni-arise" ''
    dni setup --github WJKPK/nixation --config minimal-nvim
  '';

  dni-shell = pkgs.writeShellScriptBin "dni-shell" ''
    dni shell
  '';

in {
  home.packages = [ 
    dni-arise
    dni-shell
    pkgs.devcontainer
  ];
}
