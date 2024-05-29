local lspc = require'lspconfig'

lspc.nil_ls.setup{}
lspc.clangd.setup{}
lspc.rust_analyzer.setup{}
lspc.cmake.setup{}
lspc.lua_ls.setup{}
-- This is your opts table
--
require('gen').setup({
      model = "deepseek-coder:33b-instruct-q4_K_M",
      host = "localhost", -- The host running the Ollama service.
      port = "11434", -- The port on which the Ollama service is listening.
      quit_map = "q", -- set keymap for close the response window
      retry_map = "<c-r>", -- set keymap to re-send the current prompt
      -- does not init -> NixOS from this config have already configured ollama service
      -- init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      -- Function to initialize Ollama
      command = function(options)
          local body = {model = options.model, stream = true}
          return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      display_mode = "float", -- The display mode. Can be "float" or "split".
      show_prompt = true, -- Shows the prompt submitted to Ollama.
      show_model = false, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = true, -- Never closes the window automatically.
      debug = false -- Prints errors and the command which is run.
})
