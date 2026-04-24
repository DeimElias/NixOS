#!/usr/bin/env nu

def 'main' [projects?: string] {
  let projects_dir = ($projects| default { $env | get --optional PROJECTS | default /home/chimuelo/Projects/ })
  let selection  = (glob ($projects_dir + '*/*') | str replace $projects_dir '' | to text | $in + "New Project" | fzf --tmux 80%,80%)
  let selected_project = match $selection {
    "New Project" => (newProject $projects_dir),
    "" => {return},
    _ => $selection
  }
  if ($selected_project == null) { return }
  let project = ($selected_project | parse '{language}/{name}' | get 0)
  let project_path = ($projects_dir | path join $selected_project)
  if (tmux has-session -t $'($project.name | to text -n)'| complete | $in.exit_code == 1) {
    tmux new -s $'($project.name | to text -n)' -d -c $'($project_path)'
  }
  tmux switch -t $'($project.name | to text -n)'
}

def 'newProject' [mainDir: string] {
	const lang = ['R', 'Python','Nix', 'C', 'Nu', 'Dart', 'Rust', 'Lua', 'Zig']
	let selected_lang = ($lang | str join (char nl) | fzf --tmux 80%,80%)
    if ($selected_lang | is-empty) { return null }
	let project = ("" | fzf --tmux 30%,10% --print-query --no-separator --no-info --header="Project name:" | str join | str trim)
    if ($project | is-empty) { return null }
	let relativePath = $"($selected_lang)/($project)" 
	let path = ($mainDir | path join $relativePath)
	if not ($path | path exists) {
		mkdir $path
	}
	$relativePath
}
