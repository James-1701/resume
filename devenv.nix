# Devenv is a modern development environment manager using nix.
# Upstream URL: https://devenv.sh

{
  pkgs,
  ...
}:

let
  lsp = {
    enable = true;
    package = pkgs.typescript-language-server;
  };
in
{
  packages = with pkgs; [

    live-server

    # Command runner
    just
  ];

  # Formatters
  treefmt = {
    enable = true;
    config.programs = {

      # Web formatter
      prettier.enable = true;

      # I prefer biome but its HTML formatting is broken as of writing this
      #
      # biome = {
      #   enable = true;
      #   validate.enable = false;
      #   includes = [
      #     "*.js"
      #     "*.ts"
      #     "*.mjs"
      #     "*.mts"
      #     "*.cjs"
      #     "*.cts"
      #     "*.jsx"
      #     "*.tsx"
      #     "*.d.ts"
      #     "*.d.cts"
      #     "*.d.mts"
      #     "*.json"
      #     "*.jsonc"
      #     "*.css"
      #     "*.html"
      #   ];
      #   settings.html = {
      #     formatter.enabled = true;
      #     experimentalFullSupportEnabled = true;
      #   };
      # };

      # Formatters for supporting files
      nixfmt.enable = true;
      deadnix.enable = true;
      statix.enable = true;
      # yamlfmt = {
      #   enable = true;
      #   settings.formatter.retain_line_breaks_single = true;
      # };
      mdformat = {
        enable = true;
        settings.wrap = 80;
        plugins = plugin: [ plugin.mdformat-gfm ];
      };
    };
  };

  languages = {

    # Enable Nix language support for surrounding tooling
    nix = {
      enable = true;
      lsp = {
        enable = true;
        package = pkgs.nixd;
      };
    };

    # Enable Common Web languages support (installs most basic tools)
    typescript = {
      enable = true;
      inherit lsp;
    };
    javascript = {
      enable = true;
      package = pkgs.nodejs-slim_24; # Latest LTS
      inherit lsp;
      corepack.enable = true;
      pnpm = {
        enable = true;
        package = pkgs.pnpm;
        install.enable = true;
      };
    };
  };

  git-hooks.hooks = {

    # Security & safety
    ripsecrets.enable = true;
    check-merge-conflicts.enable = true;

    # Code quality
    treefmt.enable = true;
    typos.enable = true;
    markdownlint = {
      enable = true;
      settings.configuration = {
        MD013 = {
          code_blocks = false;
          tables = false;
          urls = false;
        };
        MD060.style = "any";
        MD041 = false;
      };
    };

    # File consistency
    check-added-large-files.enable = true;
    editorconfig-checker.enable = true;
    trim-trailing-whitespace.enable = true;
    end-of-file-fixer.enable = true;
  };
}
