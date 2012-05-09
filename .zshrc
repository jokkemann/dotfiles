# zsh setup for joakimsv
setopt autolist \
	histignoredups \
	listtypes \
	correct \
	hashcmds \
	rmstarsilent \
	autoremoveslash \
	nopromptcr \
	nohup \
	hashlistall \
	braceccl \
	extended_glob \
	rc_quotes \
	prompt_subst
unsetopt hashdirs
limit coredumpsize 0

autoload colors zsh/terminfo
autoload -U compinit; compinit

limit coredumpsize 0
if  [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	eval PR_BACK_$color='%{$bg[${(L)color}]%}'
	(( count = $count + 1))
done

tty=`tty | sed 's#/#_#g;s/_dev_//'`
LOCALTTYPREFIX=`tty | sed 's#/dev/##g;s#[0-9/].*##'`

git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    if [ "$ref" ]; then
        echo "(${ref#refs/heads/})"
    fi
}

set_prompt() {
PR_NO_COLOR="%{$terminfo[sgr0]%}"
PR_SSH=''
if [[ `whoami` == root ]] ; then
   PR_COLOR=$PR_RED
#  PS1=$'%{\e[1;31m%}%n@%m%{\e[0m%}:%B%3~/%b >%# '
else
  if [[ $SSH_CONNECTION == "" ]] ; then
     PR_COLOR=$PR_BLUE
#    PS1=$'%{\e[1;32m%}%n@%m%{\e[0m%}:%B%~/%b >%# '
  else
    PR_COLOR=$PR_BLUE
    PR_SSH='(ssh)'
#    PS1=$'%{\e[1;34m%}%n@%m(ssh)%{\e[0m%}:%B%3~/%b >%# '
  fi
fi
#PROMPT='$PR_COLOR$PR_SSH%n@$PR_BACK_RED%m$PR_NO_COLOR:%B%~/%b $(git_prompt_info)>%# '
PROMPT='$PR_COLOR$PR_SSH%n@%m$PR_NO_COLOR:%B%~/%b $(git_prompt_info)>%# '
#RPROMPT='[%?]'
}
set_prompt

chpr () {
	print -Pn "]2;$1]1;$1"
#	PROMPT=$PSPREFIX'%m{%S%n%s}%!$(git_prompt_info) '
	set_prompt
}
win_name() {
	user=$USERNAME
	if [ ! "$DISPLAY" ]; then
		return
	fi
	if [ X$LOCALTTYPREFIX = Xtty ]; then
		chpr "$tty:${PWD/$HOME/\~} ($user)"
	else
		chpr "$tty:$HOSTNAME:${PWD/$HOME/\~} ($user)"
	fi
}
win_name
		
cd() {
	builtin cd $*
	win_name
}
pd() {
	builtin pushd $1
	win_name
}
po() {
	builtin popd
	win_name
}
ssh() {
	chpr $1
	/usr/bin/ssh $*
	win_name
}

eval $(lesspipe)

bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[3~" delete-char

alias l='/bin/ls -F --color=auto'
alias la='l -a'
alias ls='ls -CFal --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias make=colormake
alias du='du -k'
alias df='df -k'
alias files='nautilus --no-desktop --browser . &'
alias RI='rules binary && deb_inst'

zstyle -e ':completion:*' special-dirs \
'[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'
