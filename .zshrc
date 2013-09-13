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

parse_git_dirty() {
	git diff --quiet --ignore-submodules HEAD 2> /dev/null; [ $? -eq 1 ] && echo '*'
}

parse_git_untracked() {
	git status -su | sed -e '/^[^\?]/d'
}
git_prompt_info() {
	git_info=$(git branch --no-color 2> /dev/null | sed -e '/^[^\*] /d' -e "s/\* \(.*\)/\1$(parse_git_dirty)/")
	[ "$git_info" ] || return
	echo "($git_info)"
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
PROMPT='$PR_COLOR$PR_SSH%n@%m$PR_NO_COLOR:%B%~/%b$(git_prompt_info)>%(?..(%?%)) %# '
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

alias ls='ls -CFX --color=auto'
alias l='ls -l'
alias ll='ls -al'
alias la='ls -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias adu='sudo apt-get update && sudo apt-get dist-upgrade'
function md {
	mkdir -p $1 && cd $1
}
function checkport {
	lsof -iTCP:$1
}

if [[ -x /usr/bin/colormake ]]; then
	alias make=colormake
fi

alias du='du -k'
alias df='df -k'
alias files='nautilus --no-desktop --browser . &'
alias RI='rules binary && deb_inst'

if [[ -x /usr/bin/xmodmap ]]; then
	xmodmap -e "remove lock = Caps_Lock"
fi

. <(npm completion)
. <(karma completion)

if [[ -e ~/code/z/z.sh ]]; then
	. ~/code/z/z.sh
else
	echo "Don't forget to install z!"
fi

zstyle -e ':completion:*' special-dirs \
'[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

# Run scripts in ~/.zshrc.d
if [[ -d ~/.zshrc.d ]]; then
	for i in ~/.zshrc.d/*.zsh; do
		if [[ -r $i ]]; then
			. $i
		fi
	done
	unset i
fi

if [[ -d ~/.rvm/bin ]]; then
	PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi
