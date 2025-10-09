final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    tokyonight-tmux = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "tokyonight-tmux";
      rtpFilePath = "tmux-tokyo-night.tmux";
      version = "1.11";
      src = final.fetchFromGitHub {
        owner = "fabioluciano";
        repo = "tmux-tokyo-night";
        rev = "97cdce3e785f8a6cc1c569b87cd3020fdad7e637";
        hash = "sha256-WjDbunWmxbw/jjvc34ujOWif18POC3WVO1s+hk9SLg4=";
      };
    };
  };
}
