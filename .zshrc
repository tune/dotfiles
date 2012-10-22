# ~tune/.zshrc

#====================================================================
# Settig Environment Variable
#====================================================================
path=(
       /bin /sbin
       /usr/bin /usr/sbin
       /usr/local/bin /usr/local/sbin
       /usr/X11R6/bin
       /opt/local/bin /opt/local/sbin
)
export MANPATH=/opt/local/man:$MANPATH
export LANG=ja_JP.UTF-8
export HISTFILE=$HOME/.zhistory
export HISTSIZE=100000
export SAVEHIST=100000
export USER=$USERNAME
export HOSTNAME=$HOST
export PAGER=less
export EDITOR=vi

#====================================================================
# Setting Alias
#====================================================================
alias ls='ls -aF'
alias sl=ls
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -trl'
alias le=less
alias bd='cd $OLDPWD'
alias dc=cd
alias clr='( setopt NULLGLOB; rm -f *~ .[^.]*~ ..*~ \#*\# )'
alias grep='grep --color=always'
alias j=jobs
alias so="source ~/.zshrc"
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

#====================================================================
# Setting Extension Alias
# Usage:
# % ps aux G apache
#====================================================================
alias -g G='| grep '
alias -g L='| less '
alias -g H='| head '
alias -g T='| tail '
alias -g V='| vi '

#====================================================================
# Setting abbreviation
# http://homepage1.nifty.com/blankspace/zsh/zsh.html
#====================================================================
typeset -A myabbrev
myabbrev=(
       "ll"    "| less"
       "lg"    "| grep"
       "|h"    "| head"
       "|t"    "| tail"
       "|v"    "| vi"
       "tx"    "tar -xvzf"
)
my-expand-abbrev() {
   local left prefix
   left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
   prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
   LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev

# zsh + screen で端末に表示されてる文字列を補完する
# dabbrev
HARDCOPYFILE=/tmp/screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete () {
       local reply lines=80 # 80行分
       screen -X eval "hardcopy -h $HARDCOPYFILE"
       reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
       compadd - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
bindkey '^o^_' reverse-menu-complete

#====================================================================
# Setting Prompt
#====================================================================
PROMPT=$'%{\e]0;%n@%M:%~\a%}%S%B%n@%m%b%s%# '
RPROMPT='[%~]%*'

if [ "$TERM" = "screen" ]; then
 preexec() {
   # see [zsh-workers:13180]
   # http://www.zsh.org/mla/workers/2000/msg03993.html
   emulate -L zsh
   local -a cmd; cmd=(${(z)2})
   echo -n "^[k$cmd[1]:t^[\\"
 }
fi

#====================================================================
# Completion
#====================================================================
# zsh-completionsを利用する Github => zsh-completions  
fpath=(~/dotfiles/zsh/zsh-completions $fpath)

autoload -U compinit; compinit
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

#====================================================================
# Key Bind
# http://aquahill.net/zsh/dot.zshrc
#====================================================================
bindkey -v      #EDITOR=vi

bindkey '^U' backward-kill-line         # override kill-whole-line
bindkey '^W' kill-region                # override backward-kill-word
bindkey '^[h' vi-backward-kill-word     # override run-help
bindkey '^[.' copy-prev-word            # override insert-last-word

#[ -n " `alias runhelp`" ] && unalias run-help
#autoload run-help

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-esarch-forward-end

#====================================================================
# Color Settings
#====================================================================
autoload -U colors
colors

export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacad
export LS_COLORS='*.swp=00;44;37:*,v=5;34;93:*.vim=35:no=0:fi=0:di=32:ln=36:or=1;40:mi=1;40:pi=31:so=33:bd=44;37:cd=44;37:ex=35:*.jpg=1;32:*.jpeg=1;32:*.JPG=1;32:*.gif=1;32:*.png=1;32:*.jpeg=1;32:*.ppm=1;32:*.pgm=1;32:*.pbm=1;32:*.c=1;32:*.C=1;33:*.h=1;33:*.cc=1;33:*.awk=1;33:*.pl=1;33:*.gz=31:*.tar=31:*.zip=31:*.lha=1;31:*.lzh=1;31:*.arj=1;31:*.bz2=31:*.tgz=31:*.taz=1;31:*.html=36:*.htm=1;34:*.doc=1;34:*.txt=1;34:*.o=1;36:*.a=1;36'
LS_OPT2='--color=auto'

if [[ $UID == 0 ]]; then
 user_color="red";
else
 user_color="green";
fi

host_color="magenta";
path_color="white";
date_color="yellow";
arrobase_color="white";
sep_color="cyan";


#====================================================================
# Set Option
# See man zshoptions(1)
#====================================================================
#Do not exit on end-of-file
setopt ignore_eof
#Extend Special Characters When Create New File
setopt extended_glob

#Do not allow > redirection to truncate existing files, and >> to create files
#setopt no_clobber

#Command Correction
setopt correct
setopt correct_all

#about history
setopt bang_hist                #Defalut Enable
setopt hist_beep                #Default Enable
setopt extended_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_ignore_space
setopt append_history
setopt hist_find_no_dups
setopt inc_append_history

#about Completion
setopt always_last_prompt       #Defalut Enable
setopt auto_list                #Default Enable
setopt auto_menu
setopt auto_remove_slash        #Dafault Enable

#about List
setopt list_packed
setopt list_types

#about BEEP
setopt no_beep
setopt no_list_beep

#about Directory
setopt auto_cd
setopt auto_name_dirs
setopt auto_pushd
setopt cd_able_vars
setopt pushd_ignore_dups
setopt pushd_silent
setopt cdable_vars

#about jobs
setopt auto_resume
setopt bg_nice                  #Defalut Enable
setopt notify                   #Defalut Enable
setopt check_jobs               #Default Enable

#other settings
setopt auto_param_keys
setopt auto_param_slash
setopt chase_links
setopt notify
setopt numeric_glob_sort
setopt print_eightbit
setopt prompt_subst
setopt sh_word_split
setopt sun_keyboard_hack
setopt complete_in_word
setopt glob_dots
setopt long_list_jobs
setopt equals
#setopt xtrace
