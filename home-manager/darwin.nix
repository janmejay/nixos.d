{ config, pkgs, inputs, nixvim, ... }:
let
  user = "janmejay";
in
{
  nixpkgs.config.allowUnfree = true;
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.nixvim = {
    config = {
      enable = true;
      globals.mapleader = " ";
      opts = {
        relativenumber = true;
        number = true;
        shiftwidth = 2;
      };
      keymaps = [
        {
	  action = "<cmd>Telescope live_grep<CR>";
	  key = "<leader>gg";
	}
        {
	  action = "<cmd>Telescope find_files<CR>";
	  key = "<leader>ff";
	}
      ];
      colorschemes.catppuccin.enable = true;
      plugins = { 
        treesitter = {
          enable = true;
        };
        lsp = {
          enable = true;
	  servers = {
	    lua_ls.enable = true;
	    gopls.enable = true;    
	    rust_analyzer = {
	      enable = true;
	      installCargo = false;
	      installRustc = false;
	    };
	    nixd.enable = true;
	  };
	};
	cmp = {
	  enable = true;
	  autoEnableSources = true;

          settings = {
	    sources = [
	      {
	        name = "nvim_lsp";
	        priority = 1000;
	      }
	      {
	        name = "path";
	        priority = 300;
	      }
	      {
	        name = "nvim_lsp_signature_help";
	        priority = 1000;
	      }
	      {
	        name = "buffer";
	        priority = 500;
	      }
	      {
	        name = "copilot";
	        priority = 400;
	      }
	    ];
	    mapping = {
	      "<CR>" = "cmp.mapping.confirm({ select = true})";
	     # "<Tab>" = {
	     #   action = ''
	     #     function(fallback)
	     #       if cmp.visible() then
	     #         cmp.select_next_item()
	     #       elseif luasnip.expandable() then
	     #         luasnip.expand()
	     #       elseif luasnip.expand_or_jumpable() then
	     #         luasnip.expand_or_jump()
	     #       elseif check_backspace() then
	     #         fallback()
	     #       else
	     #         fallback()
	     #       end
	     #     end
	     #   '';
	     #   modes = [ "i" "s" ];
	     # };
	    };
	  };
	};
	oil.enable = true;
	luasnip.enable = true;
        lualine.enable = true;
        telescope = {
          enable = true;
    	extensions = {
    	  fzf-native.enable = true;
    	};
        };
        mini = {
          enable = true;
          modules.icons = { };
          mockDevIcons = true;
        };
      };
    };

  };

  home.file = {
    ".config/karabiner/assets/complex_modifications/cmd_ctrl.json".source = ../dots/karabiner/complex_modifications/cmd_ctrl.json;
    ".config/aerospace/aerospace.toml".source = ../dots/aerospace.toml;
  };


  # Common macOS tools
  home.packages = with pkgs; [
    sops
    rustup
    # nixvim.packages.${pkgs.system}.default
  ];

  programs.zsh.enable = true;
  programs.tmux.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Add more macOS/home-manager options as needed
}
