{ pkgs, ... }: {
  home.packages = [ 
    pkgs.gh 
    pkgs.peco
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "WJKPK";
    userEmail = "krupskiwojciech@gmail.com";

    extraConfig = {
      init = { defaultBranch = "main"; };
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
    };

    aliases = {
      co = "checkout";
      d = "diff";
      ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
      pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
      af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
      st = "status";
      br = "branch";
      df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
      hist = ''
        log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
      llog = ''
        log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
    };

    ignores = [ "*~" "*.swp" "*result*" ".direnv" ];
  };
}
