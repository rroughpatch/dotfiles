{
  config,
  host,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
    "nvidia_uvm"
  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    networkmanager.enable = true;
    hostName = host.hostname;
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
    firewall.enable = false;
  };

  time.timeZone = "America/Chicago";

  services.getty.autologinUser = host.username;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  hardware.opentabletdriver.enable = true;
  security.polkit.enable = true;

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    nix-ld.enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
  ];

  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
    openssh.enable = true;
    tailscale.enable = true;
  };

  users.users.${host.username}.packages = with pkgs; [
    tree
  ];

  environment.systemPackages = with pkgs; [
    neovim
    wget
    ghostty
    waybar
    git
    vesktop
    zed-editor
    obsidian
    bun
    nodejs
    typescript-go
    python3
    rustc
    cargo
    rust-analyzer
    gcc
    gnumake
    ripgrep
    fd
    curl
    btop
    eza
    bat
    cava
    fastfetch
    codex
    swww
    wlogout
    tmux
    gamescope
    osu-lazer-bin
    pavucontrol
    networkmanagerapplet
    imv
    mpv
    grim
    slurp
    pciutils
    usbutils
    unzip
    file
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
