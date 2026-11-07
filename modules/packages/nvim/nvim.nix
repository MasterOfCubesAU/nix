{ inputs, ... }: {
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      packages.nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
        wrapRc = true;

        withPython3 = false;
        withRuby = false;

        luaRcContent = ''
          require("keymaps")
          require("config")
          require("plugins")
          require("lsps")
        '';
        wrapperArgs = [
          "--suffix"
          "LD_LIBRARY_PATH"
          ":"
          "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}"
          "--suffix"
          "PATH"
          ":"
          "${lib.makeBinPath (
            with pkgs;
            [
              # General
              yazi
              ripgrep
              # Python
              basedpyright
              ruff
              # Nix
              nixd
              nixfmt
              # C
              gcc
              clang-tools
              # Rust
              cargo
              rustc
              clippy
              rust-analyzer
              rustfmt
              # JS
              typescript-language-server
            ]
            ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.wl-clipboard
          )}"
        ];
        plugins =
          with pkgs.vimPlugins;
          [
            (pkgs.vimUtils.buildVimPlugin {
              pname = "moc-nvim-config";
              version = "0.1.0";
              doCheck = false;
              src = pkgs.runCommand "moc-nvim-config-src" { } ''
                mkdir -p $out/lua
                cp -r ${./lua}/. $out/lua/
              '';
            })
            bufferline-nvim
            nvim-lspconfig
            nvim-treesitter
            plenary-nvim
            telescope-nvim
            telescope-fzf-native-nvim
            yazi-nvim
            conform-nvim
            lualine-nvim
            neocord
            oxocarbon-nvim
          ]
          ++ (with pkgs.vimPlugins.nvim-treesitter-parsers; [
            lua
            nix
            c
            cpp
            cmake
            vim
            vimdoc
            python
            rust
            go
            yaml
            json
            toml
            javascript
            typescript
            markdown
            java
            javadoc
            c_sharp
            caddy
            nginx
          ]);
      };
    };
}
