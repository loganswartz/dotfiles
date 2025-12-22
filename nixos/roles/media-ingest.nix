{ vhs-decode, pkgs, ... }:

{
  hardware.cxadc = {
    enable = true;
    group = "video";
    exportVersionVariable = true;

    parameters = {
      cxadc0 = {
        crystal = 40000000;
        level = 0;
        sixdb = false;
        tenbit = true;
        tenxfsc = 0;
        vmux = 2;
      };

      cxadc1 = {
        center_offset = -15;
        crystal = 40000000;
        level = 0;
        sixdb = false;
        tenbit = true;
        tenxfsc = 0;
        vmux = 2;
      };
    };
  };

  programs.vhs-decode = {
    enable = true;
    package = vhs-decode.outputs.packages.${pkgs.stdenv.hostPlatform.system}.vhs-decode;
    exportVersionVariable = true;
  };

  environment.systemPackages = with pkgs; [
    sox
    ffmpeg
  ];
}
