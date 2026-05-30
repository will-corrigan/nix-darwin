{ lib, font, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = null;
    extensions = [
      "catppuccin"
      "dockerfile"
      "gdscript"
      "git-firefly"
      "html"
      "material-icon-theme"
      "terraform"
      "toml"
    ];
    userSettings = {
      ui_font_family = lib.mkForce font.name;
      ui_font_size = lib.mkForce 16;
      ui_font_weight = lib.mkForce 400;
      buffer_font_family = lib.mkForce font.name;
      buffer_font_size = lib.mkForce 16;
      buffer_font_weight = lib.mkForce 400;
      theme = lib.mkForce "Catppuccin Mocha";
      icon_theme = lib.mkForce "Material Icon Theme";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      vim_mode = true;
      cursor_blink = false;
      relative_line_numbers = true;
      base_keymap = "VSCode";
      vim = {
        use_system_clipboard = "always";
        use_smartcase_find = true;
        highlight_search = true;
      };

      buffer_font_features = {
        calt = true;
        liga = true;
      };
      tab_size = 2;
      soft_wrap = "editor_width";
      scrollbar = { show = "never"; };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      show_whitespaces = "boundary";

      project_panel = {
        auto_fold_dirs = false;
        git_status = true;
        dock = "left";
      };
      auto_reveal_in_project_panel = true;

      git = {
        inline_blame = {
          enabled = true;
          delay_ms = 500;
        };
        git_gutter = "tracked_files";
      };

      formatter = "language_server";
      format_on_save = "on";

      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };

      terminal = {
        font_family = lib.mkForce font.name;
        font_size = 16;
        font_weight = lib.mkForce 400;
        shell = "system";
        working_directory = "current_project_directory";
        option_as_meta = true;
      };

      file_types = {
        tailwindcss = [ "*.css" ];
        shellscript = [ ".env" ".env.*" ];
      };

      file_scan_exclusions = [
        "**/.git"
        "**/node_modules"
        "**/dist"
        "**/build"
        "**/.next"
        "**/result"
        "**/.direnv"
        "**/target"
      ];

      languages = {
        TypeScript = {
          tab_size = 2;
          formatter = "language_server";
          format_on_save = "on";
          code_actions_on_format = { "source.organizeImports" = true; };
        };
        TSX = {
          tab_size = 2;
          formatter = "language_server";
          format_on_save = "on";
          code_actions_on_format = { "source.organizeImports" = true; };
        };
        JavaScript = {
          tab_size = 2;
          formatter = "language_server";
          format_on_save = "on";
          code_actions_on_format = { "source.organizeImports" = true; };
        };
        Go = {
          tab_size = 4;
          hard_tabs = true;
          formatter = "language_server";
          format_on_save = "on";
          code_actions_on_format = { "source.organizeImports" = true; };
        };
        Nix = {
          tab_size = 2;
          formatter = "language_server";
          format_on_save = "on";
        };
        Markdown = {
          soft_wrap = "editor_width";
          tab_size = 2;
          format_on_save = "off";
        };
        TOML = { tab_size = 2; };
        YAML = { tab_size = 2; };
      };

      lsp = {
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
              staticcheck = true;
              completeUnimported = true;
              analyses = {
                unusedparams = true;
                shadow = true;
                nilness = true;
                unusedwrite = true;
              };
              gofumpt = true;
              semanticTokens = true;
            };
          };
        };
        "tailwindcss-language-server" = {
          settings = {
            tailwindCSS = {
              emmetCompletions = true;
              classAttributes = [ "class" "className" "tw" ];
              experimental = {
                classRegex = [
                  [ "clsx\\(([^)]*)\\)" "\"([^\"]*)\"" ]
                  [ "cva\\(([^)]*)\\)" "[\"'`]([^\"'`]*)[\"'`]" ]
                  [ "cn\\(([^)]*)\\)" "\"([^\"]*)\"" ]
                ];
              };
            };
          };
        };
      };
    };
    userKeymaps = [
      {
        context = "Editor && vim_mode == normal && !VimWaiting && !menu";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
          "shift-h" = "pane::ActivatePreviousItem";
          "shift-l" = "pane::ActivateNextItem";
          "space v" = "pane::SplitRight";
          "space s" = "pane::SplitDown";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
      {
        context = "Dock";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
    ];
  };
}
