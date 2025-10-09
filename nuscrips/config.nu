#!/usr/bin/env nu
def main [dots_dir?: string] {
	let dir = ($dots_dir | default { $env | get --optional DOTFILES | default /home/chimuelo/.config/dotfiles/ })
	let config_file = (glob ($dir ++ '**') --exclude [**/.git/**] --no-dir | str replace $dir '' | to text | fzf -- --tmux 80%,80% --preview $'bat ($dir){1}')
	if (tmux has-session -t "Config" | complete | $in.exit_code == 1) {
		tmux new -s "Config" -A -d -c $'($dir)'
	}
	match (tmux list-panes -t 'Config:1.1' -F '#{pane_current_command}') {
	'nu' => (tmux send-keys -t 'Config:1.1' $'nvim ($config_file)' C-m)
	'nvim' | 'vi' | 'vim' => (tmux send-keys -t 'Config:1.1' Escape Escape $':e ($config_file)' C-m)
	}
	tmux switch -t 'Config'
}
