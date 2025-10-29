# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }@inputs:

{
  imports = [];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  nix.gc.automatic = true;

  hardware.graphics.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Indiana/Indianapolis";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
  services.playerctld.enable = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=suspend
    HandleRebootKey=suspend
  '';
  services.fwupd.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  virtualisation.docker.enable = true;

  # usb media hotplug
  services.udisks2.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    # Allow selecting Airplay devices as audio outputs
    raopOpenFirewall = true;
    extraConfig.pipewire = {
      "10-airplay" = {
        "context.modules" = [
          {
            name = "libpipewire-module-raop-discover";

            # increase the buffer size if you get dropouts/glitches
            # args = {
            #   "raop.latency.ms" = 500;
            # };
          }
        ];
      };
    };
  };

  services.blueman.enable = true;

  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [];
  };
  services.snap.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.logans = {
    isNormalUser = true;
    description = "Logan Swartzendruber";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdZJmtpKQgHHoxz1KUy9PHSdCAbUiPZLM+qFn4powmp"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDinYhmkZg/fbAz3KHWP4G7LvniqVlcx4lmljQpPh1E9ehQiosI3ApTNoHjG51cjzeOSANpak811nFcMFNCwTtKLhPuQhewEPJnAmBBCYbF0hb7Dck1/0/oZafOHF6ji9Zz9jcKZTy208sRIEohkxAaGFBJ72kA67+gqKjpD4QKACJaJoFlSzsSsu1aGeaGU1T+QZx0p9WhkZnhQPOG/KxGzJCXcqilglIq24qORQHKDqkO/4N+pWUtobDOLJSypq7TPZR8BeOwCBr07jOIggWffKkmSesC2pb+lOYTOmk3tCEY11ME9Ri0r5/w1Ls3Fv9+xZtCq8JvFaeVTf/oobGV logans@web"
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];

  # fix broken default applications
  # https://github.com/NixOS/nixpkgs/issues/409986
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gh
    wget
    tmux
    tmuxp
    neofetch

    # programming
    gcc
    gnumake
    go
    python3Full
    nodejs

    # archives
    zip
    xz
    unzip
    p7zip
    zstd
    gnutar

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    dos2unix

    # networking tools
    iperf3
    dnsutils  # `dig` + `nslookup`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing

    # misc
    pv
    boxes
    cowsay
    file
    which
    tree
    gnused
    gawk
    gnupg
    seahorse
    gnome-text-editor
    libnotify

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop # replacement of htop/nmon
    iftop # network monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    lshw

    remmina
    google-chrome
    inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    gimp-with-plugins
    gparted
    libreoffice

    # wayland
    inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
    shikane
  ];

  programs.firefox.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      cliphist
      grim
      mako
      networkmanagerapplet
      playerctl
      rofi
      slurp
      swaylock
      wdisplays
      wev
      wl-clipboard
      wlogout
      wob
    ];
    # https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland
    # https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md?ref_type=heads
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland

      # QT (needs qt5.qtwayland in systemPackages):
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # export QT_WAYLAND_FORCE_DPI=physical

      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      export WLR_RENDERER_ALLOW_SOFTWARE="1"
      export NIXOS_OZONE_WL="1"
    '';
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      # hyprland added by programs.hyprland.withUWSM
      sway = {
        prettyName = "Sway (UWSM)";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  programs.zsh.enable = true;
  # broken
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
    openFirewall = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
