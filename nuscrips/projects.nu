#!/usr/bin/env nu
def 'main' [projects?: string] {
	let projects_dir = ($projects | default $env.PROJECTS )
	let selected_project = (glob ($projects_dir + '*/*') | str replace $projects_dir '' | to text | fzf -- --tmux 80%,80%)
	let project = $selected_project | parse '{language}/{project}'
	let project_path = $projects_dir ++ $selected_project
	if (tmux has-session -t $'($project.project | to text -n)'| complete | $in.exit_code == 1) {
		tmux new -s $'($project.project | to text -n)' -A -d -c $'($project_path)'
		
	}
		tmux switch -t $'($project.project | to text -n)'
	}

