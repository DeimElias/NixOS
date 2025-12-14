#!/usr/bin/env nu

def 'newProject' [mainDir: string] {
	const lang = ['R', 'Python','Nix', 'C', 'Nu', 'Dart', 'Rust', 'Lua', 'Zig']
	let selected_lang = ($lang | to text | fzf --tmux 80%,80%)
	let project = ("" | fzf --tmux 30%,10% --print-query --no-separator --no-info --header="Project name:"| decode utf-8 | str replace "\n" "")
	let relativePath = ($selected_lang + "/" + $project) 
	let path = ($mainDir + $relativePath)
	if not ($path | path exists) {
		mkdir $path
	}
	$relativePath
}

def 'main' [projects?: string] {
	let projects_dir = ($projects| default { $env | get --optional PROJECTS | default /home/chimuelo/Projects/ })
	let selection  = (glob ($projects_dir + '*/*') | str replace $projects_dir '' | to text | $in + "New Project" | fzf --tmux 80%,80%)
	let selected_project = match $selection {
		"New Project" => (newProject $projects_dir),
		"" => null,
		_ => $selection
	}; | debug
	let project = $selected_project | parse '{language}/{name}'
	let project_path = $projects_dir ++ $selected_project
	if (tmux has-session -t $'($project.name | to text -n)'| complete | $in.exit_code == 1) {
		tmux new -s $'($project.name | to text -n)' -A -d -c $'($project_path)'
	}
		tmux switch -t $'($project.name | to text -n)'
	}
