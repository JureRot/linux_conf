# /bin/bash

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

	local CYAN_BOLD="\033[1;36m" #diverged
	local RED_BOLD="\033[1;31m" #behind
	local WHITE="\033[37m" #up to date
	local YELLOW="\033[33m" #changes
	local MAGENTA="\033[35m" #staged (added)
	local GREEN="\033[32m" #ahead (commited)

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

function color_reset {
	local COLOR_RESET="\033[0m"
	echo -e $COLOR_RESET
}

function git_branch {
	local branch=$(grep "On branch" <<< $git_status)
	if [[ -n $branch ]]; then #alternative (check if string len not zero)
		response="${response}$(echo $branch | cut -d " " -f 3)"
	fi
}

function git_status {
	#local fetch="$(git fetch --all 2> /dev/null)" #to get up-to-date data
	local git_status="$(git status 2> /dev/null)"

	#PS1='\[\033[0;30m\]a\[\033[0m\]\[\033[0;31m\]b\[\033[0m\]\[\033[0;33m\]c\[\033[0m\]\[\033[0;32m\]d\[\033[0m\]\[\033[0;36m\]e\[\033[0m\]\[\033[0;34m\]f\[\033[0m\]\[\033[0;35m\]g\[\033[0m\]\[\033[0;37m\]h\[\033[0m\]'
	
	local response =""

	#if [[ ${#branch} -gt 0 ]]; then #if str len greater than 0
	#if [[ $branch != ""]]; then #alternative (compare to empty string)
	if [[ -n $branch ]]; then #alternative (check if string len not zero)
		response="${response}("

		if [[ -n $diverged ]]; then #diverged
			response="${response}$CYAN_BOLD"
		elif [[ -n $behind ]]; then #behind
			response="${response}$RED_BOLD"
		elif [[ -n $ahead ]]; then #ahead
			response="${response}$GREEN"
		elif [[ -n $staged ]]; then #staged
			response="${response}$MAGENTA"
		elif [[ -n $not_staged ]] || [[ -n $untracked_files ]]; then #changes
			response="${response}$YELLOW"
		else #up to date
			response="${response}$WHITE"
		fi

		response="${response}$(echo $branch | cut -d " " -f 3)"
		response="${response}$COLOR_RESET"
		#response="${response})"

		response+=")" #alternative bash syntax
	fi

	echo $response
}

echo $(git_status)

#get all possible (of interest) returns of git status
#that way you will know how to parse any return to get the branch and status

#not a repo [no display]
# fatal: not a git repository (or any of the parent directories): .git

#up to date [white name of branch in brackets]

#behind [red name of branch in brackets]

#changes (changed or added files, not commited) [yellow/blue? name of branch in brackets]

#ahead (commited, not pushed) [green? name of branch in brackets]


# add git status to terminal/bash prompt (try without plugins/packages) (name of branch -> red/orange if behind, normal if git repo, blue if ahead, green if ahead and commited) [https://coderwall.com/p/pn8f0g/show-your-git-status-and-branch-in-color-at-the-command-prompt][https://gist.github.com/justintv/168835] [https://gist.github.com/sundeepgupta/b099c31ee2cc1eb31b6d]
