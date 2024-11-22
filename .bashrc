#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '
PS1='\u@\h \W > '
#PS1='> '

# Fix color compatibility
#alias tmux="TERM=screen-256color-bce tmux"
# Path Variables
# These help to display the correct color when
# using nvim inside of tmux with Alacritty (possibly other term emulators as well)
export TERM='xterm-256color'
export EDITOR='nvim'
export VISUAL='nvim'

# Enable Proton ESYNC and FSYNC for Wine/Proton gaming
# Improves compatibility and performance in Steam games with Proton.
# Some games may behave better with these disabled, so adjust if issues occur.
export PROTON_NO_ESYNC=0
export PROTON_NO_FSYNC=0

export TERMINAL="wezterm"

# Bash
# complete commmands
#complete -c man which
source /usr/share/bash-completion/bash_completion

# Set up Node Version Manager
source /usr/share/nvm/init-nvm.sh

# Load Angular CLI autocompletion.
source <(ng completion script)

# Git completion
source /usr/share/git/completion/git-completion.bash

# QMK completion
#source ~/Repos/qmk_firmware/util/qmk_tab_complete.sh

# Command not found
# Automatically search the official repositories when entering an unrecognized command
# Need pkgfile to be installed
# Update the pkgfile database with 'pkgfile -u'
source /usr/share/doc/pkgfile/command-not-found.bash

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# complete dotfiles alias git commands
source /usr/share/bash-completion/completions/git
__git_complete dotfiles __git_main
# complete -F _complete_alias dotfiles

# dotnet completion and Path updates
export PATH="$PATH:/home/daniel/.dotnet/tools"
# NOTE: Completion seems to work out of the box but maybe useful for some testing
# # bash parameter completion for the dotnet CLI -- Version 01
# _dotnet_bash_complete()
# {
#   local word=${COMP_WORDS[COMP_CWORD]}
#
#   local completions
#   completions="$(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)"
#   if [ $? -ne 0 ]; then
#     completions=""
#   fi
#
#   COMPREPLY=( $(compgen -W "$completions" -- "$word") )
# }
#
# complete -f -F _dotnet_bash_complete dotnet
#
#
# # bash parameter completion for the dotnet CLI -- Version 02
# 
# function _dotnet_bash_complete()
# {
#   local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n' # On Windows you may need to use use IFS=$'\r\n'
#   local candidates
#
#   read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)
#
#   read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
# }
#
# complete -f -F _dotnet_bash_complete dotnet

# Starship command prompt. Needs to be at the end of bashrc
eval "$(starship init bash)"
