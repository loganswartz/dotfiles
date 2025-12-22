{ pkgs, ... }:

let
  default-pinentry = pkgs.pinentry-qt;

  pinentry-auto = with pkgs; (writeShellApplication {
    name = "pinentry-auto";
    runtimeInputs = [
      default-pinentry
      pinentry-tty
    ];
    text = ''
      # Automatically use TTY pinentry when in an SSH session.
      # This usually happens automatically when no other sessions are active,
      # but it breaks when a graphical session is also currently in progress

      pe=${default-pinentry}

      case "$PINENTRY_USER_DATA" in
        *USE_TTY*)
          pe=${pinentry-tty}/bin/pinentry-tty
          ;;
        # *USE_CURSES*)
        #   pe=pinentry-curses
        #   ;;
        # *USE_GTK2*)
        #   pe=pinentry-gtk-2
        #   ;;
        # *USE_GNOME3*)
        #   pe=pinentry-gnome3
        #   ;;
        # *USE_X11*)
        #   pe=pinentry-x11
        #   ;;
        # *USE_QT*)
        #   pe=pinentry-qt
        #   ;;
      esac

      exec $pe "$@"
    '';
  });
in {
  environment.systemPackages = with pkgs; [
    default-pinentry
    pinentry-tty
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pinentry-auto;
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
}
