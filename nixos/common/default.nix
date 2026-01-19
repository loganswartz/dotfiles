# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }@inputs:

{
  imports = [
    ./audio.nix
    ./credentials.nix
    ./graphical.nix
    ./networking.nix
    ./python.nix
  ];

  nix.settings = { experimental-features = [ "nix-command" "flakes" ]; };
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # some devices need a newer kernel version for suspend to work properly
  # https://community.frame.work/t/framework-13-nixos-doesn-t-suspend/71715/2
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Set your time zone.
  time.timeZone = lib.mkDefault "America/Indiana/Indianapolis";
  services.automatic-timezoned.enable = true;

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

  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "suspend";
    HandleRebootKey = "suspend";
  };
  services.fwupd.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  virtualisation.docker.enable = true;

  # usb media hotplug
  services.udisks2.enable = true;

  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" =
        "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [ ];
  };
  services.snap.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
    ];
  };

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.logans = {
    isNormalUser = true;
    description = "Logan Swartzendruber";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdZJmtpKQgHHoxz1KUy9PHSdCAbUiPZLM+qFn4powmp"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDinYhmkZg/fbAz3KHWP4G7LvniqVlcx4lmljQpPh1E9ehQiosI3ApTNoHjG51cjzeOSANpak811nFcMFNCwTtKLhPuQhewEPJnAmBBCYbF0hb7Dck1/0/oZafOHF6ji9Zz9jcKZTy208sRIEohkxAaGFBJ72kA67+gqKjpD4QKACJaJoFlSzsSsu1aGeaGU1T+QZx0p9WhkZnhQPOG/KxGzJCXcqilglIq24qORQHKDqkO/4N+pWUtobDOLJSypq7TPZR8BeOwCBr07jOIggWffKkmSesC2pb+lOYTOmk3tCEY11ME9Ri0r5/w1Ls3Fv9+xZtCq8JvFaeVTf/oobGV logans@web"
    ];
    shell = pkgs.zsh;
  };

  # fonts
  fonts.packages = with pkgs; [ nerd-fonts.mononoki jetbrains-mono ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gh
    wget
    tmux
    tmuxp
    alacritty
    wezterm
    neofetch
    starship

    # programming
    gcc
    gnumake
    go
    python3Minimal
    uv
    pre-commit
    nodejs
    claude-code

    # archives
    zip
    xz
    zlib
    unzip
    p7zip
    zstd
    gnutar
    rar
    mediainfo

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    dos2unix

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

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop # replacement of htop/nmon
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    pciutils # lspci
    usbutils # lsusb
    lshw
    renameutils
    tzdata

    remmina
    vlc
    google-chrome
    inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    gimp-with-plugins
    gparted
    hdparm
    gnome-disk-utility
    libreoffice
    networkmanager-openvpn
  ];

  programs.firefox.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${ZSH_EXECUTION_STRING} ]]
      then
        [[ -o login ]] && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  programs.fish.enable = true;

  # uses pre-generated nix-index database from nix-index-database flake
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
