#!/bin/bash

CYAN_BOLD="\033[1;36m" #diverged
RED_BOLD="\033[1;31m" #behind
WHITE="\033[37m" #up to date
YELLOW="\033[33m" #changes
MAGENTA="\033[35m" #staged (added)
GREEN="\033[32m" #ahead (commited)
COLOR_RESET="\033[0m"

function git_color {
	local git_status="$(git status 2> /dev/null)"
	local branch=$(grep "On branch" <<< $git_status)

	local diverged=$(grep "have diverged," <<< $git_status)
	local behind=$(grep "Your branch is behind" <<< $git_status)
	local up_to_date=$(grep "Your branch is up to date" <<< $git_status)
	local not_staged=$(grep "Changes not staged for commit:" <<< $git_status)
	local untracked_files=$(grep "Untracked files:" <<< $git_status)
	local staged=$(grep "Changes to be commited:" <<< $git_status)
	local ahead=$(grep "Your branch is ahead of" <<< $git_status)

	if [[ -n $branch ]]; then #alternative (check if string len not zero)
		if [[ -n $diverged ]]; then #diverged
			echo -e "($CYAN_BOLD"
		elif [[ -n $behind ]]; then #behind
			echo -e "($RED_BOLD"
		elif [[ -n $ahead ]]; then #ahead
			echo -e "($GREEN"
		elif [[ -n $staged ]]; then #staged
			echo -e "($MAGENTA"
		elif [[ -n $not_staged ]] || [[ -n $untracked_files ]]; then #changes
			echo -e "($YELLOW"
		else #up to date
			echo -e "($WHITE"
		fi
	fi
}

function git_branch {
	local git_status="$(git status 2> /dev/null)"
	local branch=$(grep "On branch" <<< $git_status)
	if [[ -n $branch ]]; then #alternative (check if string len not zero)
		echo $(echo $branch | cut -d " " -f 3)
	fi
}

function git_reset {
	local git_status="$(git status 2> /dev/null)"
	local branch=$(grep "On branch" <<< $git_status)
	if [[ -n $branch ]]; then #alternative (check if string len not zero)
		echo -e "$COLOR_RESET)"
	fi
}

# may have performance issues
