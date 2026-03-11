{ config, pkgs, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  home.packages = with pkgs; [
    wl-clipboard
    swww
    playerctl
    libnotify
    hyprpolkitagent
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.mochaBlue;
    name = "catppuccin-mocha-blue-cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-blue-standard+default";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 8;
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      progress-color = "over #313244";
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 5;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "250, 50";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.2;
          outer_color = "rgb(89b4fa)";
          inner_color = "rgb(1e1e2e)";
          font_color = "rgb(cdd6f4)";
          fade_on_empty = true;
          placeholder_text = "";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          text = ''cmd[update:1000] echo $(date +"%I:%M %p")'';
          color = "rgb(cdd6f4)";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "ALT";

      monitor = ",1920x1080@144,auto,1";

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
        "col.inactive_border" = "rgba(313244aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 15;
          render_power = 3;
          color = "rgba(1a1a2eee)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
          "sweet, 0.25, 0.0, 0.15, 1.0"
        ];
        animation = [
          "windows, 1, 4, overshot, slide"
          "windowsOut, 1, 3, smoothOut, slide"
          "windowsMove, 1, 3, sweet"
          "fade, 1, 4, smoothIn"
          "fadeDim, 1, 4, smoothIn"
          "workspaces, 1, 4, overshot, slidevert"
          "border, 1, 10, sweet"
          "borderangle, 1, 30, sweet, loop"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      bind = [
        "$mod, Q, exec, ghostty"
        "$mod, C, killactive,"
        "$mod, M, exit"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen,"
        "$mod, SPACE, exec, rofi -show drun"
        "$mod, E, exec, thunar"
        "$mod, ESCAPE, exec, hyprlock"
        "$mod, X, exec, wlogout"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        ", Print, exec, grim - | wl-copy"
        ''$mod, Print, exec, grim -g "$(slurp)" - | wl-copy''
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        "waybar"
        "mako"
        "nm-applet --indicator"
        "blueman-applet"
        "swww-daemon"
        "systemctl --user start hyprpolkitagent"
      ];

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      input = {
        kb_options = "ctrl:nocaps";
        accel_profile = "flat";
        sensitivity = 0;
        force_no_accel = true;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      windowrule = [
        "float on, match:class pavucontrol"
        "size 800 500, match:class pavucontrol"
        "center on, match:class pavucontrol"
        "float on, match:class blueman-manager"
        "float on, match:class nm-connection-editor"
        "float on, match:class .blueman-manager-wrapped"
      ];
    };
  };

  programs = {
    zsh = {
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      profileExtra = ''
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec start-hyprland
        fi
      '';
      initContent = ''
        if [ -z "$TMUX" ] && [ "$TERM_PROGRAM" = "ghostty" ]; then
          tmux has-session -t main 2>/dev/null || tmux new-session -d -s main
          exec tmux new-session -t main
        fi
      '';
    };

    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 34;
          spacing = 0;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [
            "pulseaudio"
            "network"
            "bluetooth"
            "tray"
          ];

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = "I";
              "2" = "II";
              "3" = "III";
              "4" = "IV";
              "5" = "V";
            };
            persistent-workspaces = {
              "*" = 5;
            };
          };

          clock = {
            format = "{:%a %b %d  %I:%M %p}";
            tooltip-format = "<tt>{calendar}</tt>";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "  muted";
            format-icons = {
              default = [
                " "
                " "
                " "
              ];
            };
            on-click = "pavucontrol";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            scroll-step = 5;
          };

          network = {
            format-wifi = "  {essid}";
            format-ethernet = "  {ifname}";
            format-disconnected = "  offline";
            tooltip-format = "{ipaddr}/{cidr}";
            on-click = "nm-connection-editor";
          };

          bluetooth = {
            format = "";
            format-connected = " {device_alias}";
            format-disabled = "";
            on-click = "blueman-manager";
            tooltip-format = "{status}";
          };

          tray.spacing = 10;
        };
      };
      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", sans-serif;
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background: rgba(17, 17, 27, 0.85);
          color: #cdd6f4;
          border-bottom: 2px solid rgba(137, 180, 250, 0.25);
        }

        #workspaces button {
          padding: 0 8px;
          color: #585b70;
          border: none;
          border-radius: 0;
          background: transparent;
          transition: all 0.2s ease;
        }

        #workspaces button.active {
          color: #89b4fa;
          border-bottom: 2px solid #89b4fa;
        }

        #workspaces button:hover {
          color: #b4befe;
          background: rgba(137, 180, 250, 0.1);
        }

        #clock {
          color: #cdd6f4;
          font-weight: 600;
        }

        #pulseaudio {
          color: #f9e2af;
          padding: 0 12px;
        }

        #pulseaudio.muted {
          color: #585b70;
        }

        #network {
          color: #a6e3a1;
          padding: 0 12px;
        }

        #network.disconnected {
          color: #f38ba8;
        }

        #bluetooth {
          color: #89b4fa;
          padding: 0 12px;
        }

        #tray {
          padding: 0 12px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        tooltip {
          background: rgba(17, 17, 27, 0.95);
          border: 1px solid #89b4fa;
          border-radius: 8px;
        }

        tooltip label {
          color: #cdd6f4;
        }
      '';
    };

    tmux = {
      enable = true;
      prefix = "C-a";
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      terminal = "tmux-256color";
      escapeTime = 0;
      historyLimit = 10000;
      extraConfig = ''
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5
        set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
        set -g status-left "#[bg=#89b4fa,fg=#1e1e2e,bold] #S #[bg=#1e1e2e] "
        set -g status-right "#[fg=#6c7086]%I:%M %p "
        set -g status-left-length 30
        set -g window-status-format "#[fg=#6c7086] #I:#W "
        set -g window-status-current-format "#[fg=#89b4fa,bold] #I:#W "
        set -g pane-border-style "fg=#313244"
        set -g pane-active-border-style "fg=#89b4fa"
        set -g message-style "bg=#1e1e2e,fg=#cdd6f4"
      '';
    };

    rofi = {
      enable = true;
      package = pkgs.rofi;
      terminal = "ghostty";
      location = "center";
      extraConfig = {
        modi = "drun,run,window";
        show-icons = true;
        drun-display-format = "{name}";
        disable-history = false;
        sorting-method = "fzf";
      };
      theme = {
        "*" = {
          bg = mkLiteral "#1e1e2e";
          bg-alt = mkLiteral "#181825";
          fg = mkLiteral "#cdd6f4";
          fg-alt = mkLiteral "#6c7086";
          accent = mkLiteral "#89b4fa";
          urgent = mkLiteral "#f38ba8";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "window" = {
          width = 500;
          background-color = mkLiteral "@bg";
          border = mkLiteral "2px solid";
          border-color = mkLiteral "@accent";
          border-radius = 12;
        };

        "mainbox".padding = 12;

        "inputbar" = {
          background-color = mkLiteral "@bg-alt";
          border-radius = 8;
          padding = mkLiteral "8px 12px";
          spacing = 8;
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
        };

        "prompt".text-color = mkLiteral "@accent";

        "entry" = {
          placeholder = "Search...";
          placeholder-color = mkLiteral "@fg-alt";
        };

        "listview" = {
          lines = 8;
          columns = 1;
          fixed-height = false;
          margin = mkLiteral "12px 0 0";
          spacing = 4;
        };

        "element" = {
          padding = mkLiteral "8px 12px";
          border-radius = 8;
          spacing = 8;
        };

        "element normal active".text-color = mkLiteral "@accent";

        "element selected normal, element selected active" = {
          background-color = mkLiteral "@accent";
          text-color = mkLiteral "@bg";
        };

        "element-icon" = {
          size = 24;
          vertical-align = mkLiteral "0.5";
        };

        "element-text".vertical-align = mkLiteral "0.5";
      };
    };
  };
}
