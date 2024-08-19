# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/mnt/work" = {
    device = "/dev/disk/by-label/work";
    fsType = "ext4";
  };

  fileSystems."/home/janmejay/projects" = {
    device = "/mnt/work/projects";
    options = [ "bind" ];
  };

  networking.hostName = "jnix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
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

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.janmejay = {
    isNormalUser = true;
    description = "Janmejay Singh";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    emacs
    wget
    curl
    zsh
    git
  ];

  environment.etc."dnsmasq.d/caching.conf".text = ''
    #localise-queries
    #host-record=repository.rubrik.com,172.17.0.1
    '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
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
      "/mnt/work/projects".d = {
        mode = "0750";
        user = "janmejay";
        group = "root";
      };
      "/mnt/work/pan-jail".d = {
        mode = "0750";
        user = "janmejay";
        group = "root";
      };
    };
  };

  services.dnsmasq.alwaysKeepRunning = true;
  services.dnsmasq.settings = {
    server = [ "8.8.8.8" "8.8.4.4" ];
    cache-size = 500;
    conf-dir = "/etc/dnsmasq.d,*.conf";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
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

  system.stateVersion = "24.05"; # never change
}

