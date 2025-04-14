return {
    {
        "olimorris/codecompanion.nvim",
        enabled = vim.g.ai_support,
        dependencies = {
          { "nvim-treesitter/nvim-treesitter"},
          { "nvim-lua/plenary.nvim" },
        },
        event = "BufRead",
        opts = {
          display = {
            action_palette = {
              provider = "telescope",
            },
          },
          opts = {
            system_prompt = function()
              return [[
                You are a technical advisor to an experienced software engineer working in Neovim.
                
                Assume advanced programming knowledge and familiarity with software engineering principles.
                
                When responding:
                - Prioritize technical depth and architectural implications
                - Focus on edge cases, performance considerations, and scalability
                - Discuss trade-offs between different approaches when relevant
                - Skip explanations of standard patterns or basic concepts unless requested
                - Reference advanced patterns, algorithms, or design principles when applicable
                - Prefer showing code over explaining it unless analysis is specifically requested
                
                For code improvement:
                - Focus on optimizations beyond obvious refactorings
                - Highlight potential concurrency issues, memory management concerns, or runtime complexity
                - Consider backwards compatibility, maintainability, and testing implications
                - Suggest modern idioms and language features when appropriate
                
                For architecture discussions:
                - Consider system boundaries, coupling concerns, and dependency management
                - Address long-term maintenance and extensibility implications
                - Discuss relevant architectural patterns without overexplaining them
                
                Deliver responses with professional brevity. Skip preamble and unnecessary context.
              ]]
            end,
          },
          strategies = {
            chat = {
              adapter = "ollama-qwen2.5-coder",
              slash_commands = {
                ['buffer'] = { opts = { provider = 'telescope' } },
                ['file'] = { opts = { provider = 'telescope' } },
                ["files"] = { opts = { provider = 'telescope' } },
              },
            },
            inline = {
              adapter = "ollama-qwen2.5-coder",
            },
          },
          adapters = {
            ["ollama-qwen2.5-coder"] = function()
              return require("codecompanion.adapters").extend(
                "ollama",
                {
                  name = "qwen2.5-coder",
                  schema = {
                    model = {
                      default = vim.g.ai_model,
                    },
                    num_ctx = {
                      default = 32768,
                    },
                  },
                }
              )
            end,
          },
       },
    },
}
