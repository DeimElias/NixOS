#!/usr/bin/env nu

def "main" [diff:float] {
	hyprctl getoption cursor:zoom_factor | parse "{field}: {value}" | get value.0 | detect type | $in + $diff  | hyprctl keyword cursor:zoom_factor $in
}
