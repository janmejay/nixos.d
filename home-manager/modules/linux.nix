{ config, pkgs, lib, ... }:
let
  cfg = config.linux;

  warpd = pkgs.callPackage ../../pkgs/warpd {};
  hackery = pkgs.callPackage ../../pkgs/hackery {};
  find-cursor = pkgs.callPackage ../../pkgs/find-cursor {};
in
{
  options.linux = {
    enable = lib.mkEnableOption "Pull linux specific config / pkgs";
  };

  config = lib.mkIf cfg.enable {
    home.file = { 
      ".Xdefaults".source = ../../dots/Xdefaults;
    };

    home.packages = with pkgs; [
        # local (custom) v
        warpd
        hackery
        copyq
        find-cursor

        # public v
        patchelf
        sysstat
        timg
        xorg.xkill
        moreutils
        pistol
        tcpdump
        gcc
        nix-index
        graphviz
        vscode-fhs
        (jetbrains.plugins.addPlugins jetbrains.idea-community [ "github-copilot" ])
        squid
        dig
        bc
        rlwrap
        xautolock
        i3lock
        zoom-us
        pavucontrol
        wireplumber
        networkmanagerapplet
        xclip
        xfce.xfce4-screenshooter
        xfce.thunar
        nomacs # image viewer
        gnumake
        tree
        eza
        git
        firefox
        google-chrome
        tmux
        python3
        lsof
        gdb
        bash
        gimp
        feh
        pstree
        ffmpeg
        vlc
        file
        openjdk
        nodejs
        neovim
        fd
      ];
  };
}
