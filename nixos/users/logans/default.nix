{ config, pkgs, lib, ... }@inputs:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home.username = "logans";
  home.homeDirectory = "/home/logans";

  # graphical session services
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  services.hypridle = {
    enable = true;
    settings = let
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    in {
      general = {
          lock_cmd = "pidof hyprlock || hyprlock";  # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session";  # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 300;  # 5 min
          on-timeout = "${brightnessctl} -s set 10";  # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "${brightnessctl} -r";  # monitor backlight restore.
        }

        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        {
          timeout = 300;  # 5 min
          on-timeout = "${brightnessctl} -sd rgb:kbd_backlight set 0";  # turn off keyboard backlight.
          on-resume = "${brightnessctl} -rd rgb:kbd_backlight";  # turn on keyboard backlight.
        }

        {
          timeout = 600;  # 10 min
          on-timeout = "loginctl lock-session";  # lock screen when timeout has passed
        }

        {
          timeout = 630;  # 10.5 min
          on-timeout = "hyprctl dispatch dpms off";  # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && ${brightnessctl} -r";  # screen on when activity is detected after timeout has fired.
        }

        {
          timeout = 1800;  # 30 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  programs.hyprlock.enable = true;
  services.hyprpolkitagent.enable = true;
  services.shikane.enable = true;
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
  services.cliphist.enable = true;
  services.swayosd.enable = true;
  services.swww = {
    enable = true;
    package = inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww;
  };
  services.udiskie = {
    enable = true;
    settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        # program_options = {
        #     # replace with your favorite file manager
        #     file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        # };
    };
  };
  # control media via headset buttons
  services.mpris-proxy.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    difftastic
    glow  # markdown previewer in terminal
  ];

  programs.git.enable = true;
  programs.alacritty.enable = true;
  programs.wlogout = {
    enable = true;
    style = ''
      @import "${config.home.homeDirectory}/.config/matugen/generated/colors.css";

      window {
        /** backdrop */
        background-color: alpha(@shadow, 0.8);
      }

      button {
        font-family: Mononoki Nerd Font Mono;
        font-size: 18px;
        font-weight: bold;
        color: @on_surface;
        text-decoration-color: @on_surface;

        background-color: @surface;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;

        border-radius: 0;
        border-color: @primary_fixed_dim;
        border-style: solid;
        border-width: 1px;
      }

      button:focus, button:active, button:hover {
        background-color: @primary_fixed_dim;
        color: @on_primary;
        outline-style: none;
      }

      #lock {
        background-image: image(url("${config.home.homeDirectory}/.dotfiles/hyprland/.config/wlogout/icons/lock.svg"));
      }

      #logout {
        background-image: image(url("${config.home.homeDirectory}/.dotfiles/hyprland/.config/wlogout/icons/logout.svg"));
      }

      #suspend {
        background-image: image(url("${config.home.homeDirectory}/.dotfiles/hyprland/.config/wlogout/icons/suspend.svg"));
      }

      #hibernate {
        background-image: image(url("${config.home.homeDirectory}/.dotfiles/hyprland/.config/wlogout/icons/hibernate.svg"));
      }

      #shutdown {
        background-image: image(url("${config.home.homeDirectory}/.dotfiles/hyprland/.config/wlogout/icons/shutdown.svg"));
      }

      #reboot {
        background-image: image(url("${config.home.homeDirectory}/.dotfiles/hyprland/.config/wlogout/icons/reboot.svg"));
      }
    '';
  };

  programs.zsh = {
    enable = true;
    initContent = lib.mkAfter ''
      source "${config.home.homeDirectory}/.dotfiles/zsh/.zshrc"
    '';
  };

  xdg.configFile."hypr/hyprland.conf".source = symlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/hypr/hyprland.conf";
  xdg.configFile."hypr/hyprlock.conf".source = symlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/hypr/hyprlock.conf";
  xdg.configFile."xdg-desktop-portal" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/xdg-desktop-portal";
    recursive = true;
  };
  xdg.configFile."matugen" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/matugen";
    recursive = true;
  };
  xdg.configFile."mako" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/mako";
    recursive = true;
  };
  xdg.configFile."nvim" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
    recursive = true;
  };
  xdg.configFile."rofi" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/rofi";
    recursive = true;
  };
  xdg.configFile."sway" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/sway";
    recursive = true;
  };
  xdg.configFile."swaylock" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/swaylock";
    recursive = true;
  };
  xdg.configFile."swayosd" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/swayosd";
    recursive = true;
  };
  xdg.configFile."waybar" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/waybar";
    recursive = true;
  };
  xdg.configFile."wezterm" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/wezterm/.config/wezterm";
    recursive = true;
  };
  xdg.configFile."wpaperd" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/wpaperd";
    recursive = true;
  };

  home.file.".tmux.conf".source = symlink "${config.home.homeDirectory}/.dotfiles/tmux/.tmux.conf";

  home.file.".aliases".source = symlink "${config.home.homeDirectory}/.dotfiles/zsh/.aliases";
  home.file.".antigenrc".source = symlink "${config.home.homeDirectory}/.dotfiles/zsh/.antigenrc";

  home.file.".gitconfig".source = symlink "${config.home.homeDirectory}/.dotfiles/git/.gitconfig";
  home.file.".git-template" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/git/.git-template";
    recursive = true;
  };

  xdg.configFile."alacritty" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/alacritty/.config/alacritty";
    recursive = true;
  };

  xdg.configFile."uwsm/env".text = ''
    # https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland
    # https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md?ref_type=heads
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

    # inject personal scripts
    export PATH="${config.home.homeDirectory}/.dotfiles/sway/.local/bin:$PATH"
  '';

  # force overwrite default config file
  xdg.dataFile."applications/mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
  home.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";

  # dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    gtk2.force = true;
  };

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/.go";
  };

  systemd.user.sessionVariables = config.home.sessionVariables;
  systemd.user.services.matugen-initialize = {
    Unit = {
      Description = "Initialize Matugen";
      Before = [ config.wayland.systemd.target ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'if [ \"$(${pkgs.findutils}/bin/find \"${config.home.homeDirectory}/.config/matugen/generated/\" -type f)\" = \"\" ]; then ${pkgs.matugen}/bin/matugen color hex ffffff; fi'";
    };
    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
