{ config, pkgs, lib, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home.username = "logans";
  home.homeDirectory = "/home/logans";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    difftastic
    glow  # markdown previewer in terminal
  ];

  programs.git.enable = true;
  programs.alacritty.enable = true;
  programs.waybar.enable = true;

  programs.zsh = {
    enable = true;
    initContent = lib.mkAfter ''
      source "${config.home.homeDirectory}/.dotfiles/zsh/.zshrc"
    '';
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
  xdg.configFile."waybar" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/waybar";
    recursive = true;
  };
  xdg.configFile."wob" = {
    source = symlink "${config.home.homeDirectory}/.dotfiles/sway/.config/wob";
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

  home.sessionPath = [
    "${config.home.homeDirectory}/.dotfiles/sway/.local/bin"
  ];

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
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/.go";
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

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
