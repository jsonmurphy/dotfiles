{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = "pedantic";
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "atropos"; # Define your hostname.
  networking.wireless = with builtins; {
    # Enables wireless support via wpa_supplicant.
    enable = true;
    # Edit ./wireless.json to setup specific wifi connection
    networks = if pathExists ./wireless.json then fromJSON (readFile ./wireless.json) else {};
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    #i3wm-themer
    (polybar.override { i3Support = true; }) rofi nitrogen rxvt_unicode alsaUtils
    (python3.withPackages(ps: with ps; [pip setuptools pyyaml]))
  ];
  environment.variables.EDITOR = "nvim";

  fonts.fonts = with pkgs; [
    source-code-pro
    nerdfonts
    font-awesome
    terminus_font
    roboto
    hasklig
  ];

  users.defaultUserShell = pkgs.fish;
  users.users.${defaultUser} = {
    initialPassword = "nixos";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
  };

  security.sudo.wheelNeedsPassword = false;

  #security.pam.loginLimits = [{
  #  domain = "*";
  #  item = "nofile";
  #  type = "soft";
  #  value = "20000";
  #}];

  services.compton = {
    enable          = true;
    fade            = true;
    inactiveOpacity = 0.9;
    shadow          = true;
    fadeDelta       = 4;
    fadeExclude = ["name ~= 'Chrome$'"];
    opacityRules = ["100:name ~= 'Chrome$'"];
  };

  services.blueman.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
	  enable = true;
	  package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.sddm.enable = true;
  #services.xserver.windowManager.awesomewm.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [i3lock];
  };
  # services.hydra = {
  #   enable = true;
  #   hydraURL = "http://localhost:3000";
  #   notificationSender = "hydra@localhost";
  #   buildMachinesFiles = [];
  #   useSubstitutes = true;
  # };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: rec {
    polybar = pkgs.polybar.override {
      i3Support = true;
    };
  };
}
