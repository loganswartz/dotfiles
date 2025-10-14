{ ... }:

{
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  # Install the driver
  services.fprintd.enable = true;

  # disable fingerprint auth when the lid is closed
  # otherwise, it'll always prompt for fingerprint auth before password
  # inspired by: https://unix.stackexchange.com/a/678610
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      # args format: button/lid LID <open|close>
      args=($1)

      case "''${args[2]}" in
        close)
          systemctl stop fprintd

          # workaround equivalent of "systemctl mask fprintd"
          # https://discourse.nixos.org/t/temporarily-disabling-a-systemd-service/26225/13
          ln -s /dev/null /run/systemd/transient/fprintd.service
          ;;
        open)
          # workaround equivalent of "systemctl unmask fprintd"
          rm -f /run/systemd/transient/fprintd.service

          systemctl start fprintd
          ;;
      esac

      systemctl daemon-reload
    '';
  };
}
