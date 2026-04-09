#!/usr/bin/env nu

def "main" [] {
	tmux display-popup -h 68% -w 66% -x 100 -y 100 -T Resources -E "btop"
}
