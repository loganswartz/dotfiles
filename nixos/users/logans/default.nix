{ username }:

{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (lib.elem username config.host.users) {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${username} = {
      isNormalUser = true;
      description = "Logan Swartzendruber";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "audio"
        "video"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdZJmtpKQgHHoxz1KUy9PHSdCAbUiPZLM+qFn4powmp"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDinYhmkZg/fbAz3KHWP4G7LvniqVlcx4lmljQpPh1E9ehQiosI3ApTNoHjG51cjzeOSANpak811nFcMFNCwTtKLhPuQhewEPJnAmBBCYbF0hb7Dck1/0/oZafOHF6ji9Zz9jcKZTy208sRIEohkxAaGFBJ72kA67+gqKjpD4QKACJaJoFlSzsSsu1aGeaGU1T+QZx0p9WhkZnhQPOG/KxGzJCXcqilglIq24qORQHKDqkO/4N+pWUtobDOLJSypq7TPZR8BeOwCBr07jOIggWffKkmSesC2pb+lOYTOmk3tCEY11ME9Ri0r5/w1Ls3Fv9+xZtCq8JvFaeVTf/oobGV logans@web"
      ];
      shell = pkgs.zsh;
    };
  };
}
