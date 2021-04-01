{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = "pedantic";
  syschdemd = import ./syschdemd.nix { inherit lib pkgs config defaultUser; };
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  # WSL is closer to a container than anything else
  boot.isContainer = true;

  environment.noXlibs = lib.mkForce false;
  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;
  environment.systemPackages = with pkgs; [ wget neovim git ];
  environment.variables.EDITOR = "nvim";

  fonts.fonts = with pkgs; [
    source-code-pro
    nerdfonts
    font-awesome
    terminus_font
    roboto
    hasklig
  ];

  networking.dhcpcd.enable = false;

  users.defaultUserShell = pkgs.fish;
  users.users.${defaultUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.root = {
    shell = "${syschdemd}/bin/syschdemd";
    # Otherwise WSL fails to login as root with "initgroups failed 5"
    extraGroups = [ "root" ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Disable systemd units that don't make sense on WSL
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;

  security.pam.loginLimits = [{
    domain = "*";
    item = "nofile";
    type = "soft";
    value = "20000";
  }];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.awesome.enable = true;
}
