{ config, lib, pkgs, sops, ... }:
let
  dev-utils = builtins.fetchGit {
    url = "https://github.com/janmejay/dev_utils.git";
    rev = "b2ac225f3884a46faca487f0c7835941a040cf28";
    submodules = true;
    ref = "nixos";
  };

 pan-jail-files = {
   dumpXml = builtins.readFile "${dev-utils}/pan_jail/pan-jail.dumpxml";
   netXml = builtins.readFile "${dev-utils}/pan_jail/net.xml";
 };

 secret_owner = { owner = "janmejay"; };
in {
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPatches = [{
      name = "dev-config";
      patch = null;
      extraConfig = ''
          FUNCTION_ERROR_INJECTION y
          FAULT_INJECTION y
          FAULT_INJECTION_DEBUG_FS y
          FAIL_FUNCTION y
        '';
    }];
  };

  fileSystems."/mnt/work" = {
    device = "/dev/disk/by-label/work";
    fsType = "ext4";
  };

  fileSystems."/home/janmejay/projects" = {
    device = "/mnt/work/projects";
    options = [ "bind" ];
  };

  sops.defaultSopsFile = ../secrets/data.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
  sops.secrets."pan-jail/pan-jail.sh" = {
    owner = "janmejay";
    mode = "0700";
    format = "binary";
    sopsFile = ../secrets/pan-jail/pan-jail.sh;
    path = "/mnt/work/bin/pan-jail.sh";
  };

  sops.secrets."squid_cert.pem" = secret_owner;
  sops.secrets."squid_key.pem" = secret_owner;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";
  services.xserver.displayManager.lightdm = {
    background = "/etc/bg.png";
    greeters.gtk = {
      indicators = [
        "~host"
        "~spacer"
        "~clock"
        "~spacer"
        "~session"
        "~language"
        "~a11y"
        "~power"
      ];
      extraConfig = ''
        position=50%,center 80%,center
        '';
    };
  };

  services.xserver.xkb.layout = "us";

  services.printing.enable = true;

  hardware.pulseaudio.enable = true;

  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
  };

  users = {
    groups = {
      janmejay = {
        gid = 1000;
        name = "janmejay";
      };
    };
    users = {
      janmejay = {
        uid = 1000;
        group = "janmejay";
        isNormalUser = true;
        description = "Janmejay Singh";
        extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
        packages = with pkgs; [];
        shell = pkgs.zsh;
      };
      passmaster = {
        uid = 1001;
        isNormalUser = true;
        description = "Pass Master";
        shell = "/sbin/nologin";
      };
      guest = {
        uid = 1002;
        isNormalUser = true;
        description = "Guest";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    emacs
    wget
    curl
    zsh
    git
    lvm2
    linux-manual
    man-pages
    man-pages-posix
  ];

  environment.etc = {
    "dnsmasq.d/caching.conf".text = ''
      #localise-queries
      #host-record=repository.rubrik.com,172.17.0.1
      '';
    "bg.png".source = ../art/nix-wallpaper-binary-black.png;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.zsh.enable = true;

  services.openssh.enable = true;
  services.dnsmasq.enable = true;
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "layer(capslock)";
          alt = "overload(alt, esc)";
          meta = "overload(meta, esc)";
          esc = "toggle(nav)"; # before navA this was `capslock`
        };
        "capslock:C" = {};
        nav = {
          capslock = "layer(navC)";
          alt = "overload(navA, esc)";
        };
        "navC:C" = {
          n = "down";
          p = "up";
          f = "right";
          b = "left";
          a = "home";
          e = "end";
        };
        "navA:A" = {
          f = "macro(right 20ms right)";
          b = "macro(left 20ms left)";
          esc = "esc";
        };
      };
    };
  };


  systemd.tmpfiles.settings = {
    "dnsmasq" = {
      "/etc/dnsmasq.d".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
    };
    "routing" = {
      "/etc/iproute2".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
    };
    "work" = {
      "/mnt/work".d = {
        mode = "0750";
        user = "root";
        group = "wheel";
      };
      "/mnt/work/bin".d = {
        mode = "0755";
        user = "root";
        group = "wheel";
      };
      "/mnt/work/projects".d = {
        mode = "0750";
        user = "janmejay";
        group = "root";
      };
      "/mnt/work/overlay.d".d = {
        mode = "0750";
        user = "janmejay";
        group = "root";
      };
      "/mnt/work/pan-jail".d = {
        mode = "0750";
        user = "janmejay";
        group = "root";
      };
      "/mnt/work/pan-jail/pan-jail.dumpxml".f.argument = builtins.replaceStrings ["\n"] ["\\n"] pan-jail-files.dumpXml;
      "/mnt/work/pan-jail/net.xml".f.argument = builtins.replaceStrings ["\n"] ["\\n"] pan-jail-files.netXml;
      "/mnt/work/pan-jail/README".f.argument = "Copy over bionic.qcow2 and run 'pan-jail.sh import' the first time\n";
    };
  };

  system.activationScripts = {
    tmpfilesSvcRestart.text = "${pkgs.systemd}/bin/systemctl restart systemd-tmpfiles-resetup";
  };

  services.dnsmasq.alwaysKeepRunning = true;
  services.dnsmasq.settings = {
    server = [ "8.8.8.8" "8.8.4.4" ];
    cache-size = 500;
    conf-dir = "/etc/dnsmasq.d,*.conf";
  };

  networking.firewall.enable = false;

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
      daemon.settings = {
        insecure-registries = [ "10.0.0.0/8" ];
        data-root = "/mnt/work/docker";
      };
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf.enable = true;
      };
    };
  };
}

