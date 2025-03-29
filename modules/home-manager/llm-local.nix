{ lib, config, ... }:
let inherit (lib) mkOption types;
in {
  options = {
    aiCodingSupport = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable AI coding with vim";
      };
      llmModelName = mkOption {
        type = types.str;
        default = "";
        description = "The name of the LLM model to use for AI coding support.";
      };
    };
  };
  config = {
    assertions = [{
      assertion = (config.aiCodingSupport.enable -> config.aiCodingSupport.llmModelName != "");
      message = "LLM model name must be set when AI coding support is enabled.";
    }];
  };
}
