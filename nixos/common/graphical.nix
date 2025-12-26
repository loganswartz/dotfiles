{ pkgs, swww, ... }:

{
  environment.systemPackages = with pkgs; [
    # wayland
    brightnessctl
    cava
    cliphist
    grim
    libnotify
    mako
    networkmanagerapplet
    playerctl
    rofi
    shikane
    slurp
    swaylock
    swayosd
    swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wlogout
  ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  # services.displayManager.sddm.enable = true;
  services.displayManager = {
    gdm.enable = true;
    defaultSession = "hyprland-uwsm";
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      # hyprland added by programs.hyprland.withUWSM
      sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };
  };

  # fix broken default applications
  # https://github.com/NixOS/nixpkgs/issues/409986
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
