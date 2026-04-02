if true then
  return {}
end

return {
  "neovim/nvim-lspconfig",
  dependencies = { "stevearc/conform.nvim" }, -- Opcional: para formateo
  config = function()
    local lspconfig = require("lspconfig")

    -- Función ultra-precisa para capturar el python de pyenv
    local function get_python_path()
      local handle = io.popen("pyenv prefix 3.11.6 2>/dev/null")
      local root = handle:read("*a"):gsub("%s+", "")
      handle:close()
      if root ~= "" then
        return root .. "/bin/python"
      end
      return "python3"
    end

    -- CONFIGURACIÓN DE ERRORES EN LÍNEA (Diagnostics)
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- Carácter que aparece al lado del error
        source = "always", -- Muestra si el error es de Pyright, Ruff, etc.
      },
      float = { border = "rounded" },
      update_in_insert = true,
      severity_sort = true,
    })

    lspconfig.pyright.setup({
      on_attach = function(client, bufnr)
        -- Mapeo para ver el error completo en un flotante si la línea es muy larga
        vim.keymap.set("n", "ge", vim.diagnostic.open_float, { buffer = bufnr })
      end,
      settings = {
        python = {
          pythonPath = get_python_path(),
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace", -- Escanea todo el proyecto, no solo el archivo abierto
            typeCheckingMode = "basic",
          },
        },
      },
    })
  end,
}
