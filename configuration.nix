# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Change to your name
  users.users.stan = {
    isNormalUser = true;
    description = "stan";
    extraGroups = [ "networkmanager" "wheel" "video" "audio"];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  # All necessary packages recommended by https://wiki.hyprland.org/
  environment.systemPackages = with pkgs; [
	appimage-run # Paired with appimage-run to run .AppImage files
	brave # browser
	blueberry #bluetooth
	dunst
	git
	hyprcursor
	hypridle
	hyprlock
	hyprpaper
	hyprpicker
	kitty
	libsecret # Paired with appimage-run to run .AppImage files
	neofetch
	networkmanagerapplet
	pipewire
	polkit # Priviledge management
	rofi
	rofi-bluetooth
	rofi-screenshot
	rofi-power-menu
	vim
	waybar # Alternative: eww
	webcord
	wireplumber
  	wget
	xdg-desktop-portal-gtk
	xdg-desktop-portal-hyprland
  ];

  programs = {
	appimage.binfmt = true; # .AppImage files as executable bin
	light.enable = true;
	hyprland.enable = true;
	sway.enable = true;
	sway.wrapperFeatures.gtk = true;
	thunar.enable = true; #File managers
	xfconf.enable = true; #Required for Thunar https://nixos.wiki/wiki/Thunar
  };

  programs.bash.shellAliases = {
  };

  # Nvidia: Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  services.gnome.gnome-keyring.enable = true;
  services.pipewire = {
	enable = true;
	audio.enable = true;
	pulse.enable = true;
	alsa.enable = true;
    alsa.support32Bit = true;
	jack.enable = true;
	wireplumber.enable = true;
  };

  # Some apps can't open file if xdg.portal is not enabled
  # Don't forget to restart your xdg-desktop-portal-gtk.service
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  hardware = {
    bluetooth.enable = true;
    opengl.enable = true; # Nvidia: Enable opengl for
  };

  # Nvidia
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
