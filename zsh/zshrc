# ~tune/.zshrc

#====================================================================
# Change Directory(For Cygwin)
#====================================================================
cd "${HOME}"

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
#長いディレクトリを省略表示したいときは以下をコメントアウトする
#case "$TERM" in
#    xterm*|kterm*|rxvt*)
#    PROMPT=$(print "%B%{\e[34m%}%m:%(5~,%-2~/.../%2~,%~)%{\e[33m%}%# %b")
#    PROMPT=$(print "%{\e]2;%n@@%m: %~^G%}$PROMPT") # title bar
#    ;;
#    *)
#    PROMPT='%m:%c%# '
#    ;;
#esac

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
#hosts=(`awk '{ sub(/[^A-Za-z0-9.:%-].*/, ""); print }' ~/.ssh/known_hosts* | sort | uniq`)
#compctl -k hosts ssh ping telnet rsh rmserver mtr rmhost add_zshrc add_key

autoload -U compinit;compinit -u
autoload zmv

zstyle ':completion:*' groupname ''
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format '%B------> No matches for: %d%b'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:(ssh|scp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp):*' users $users
zstyle ':completion:*' matcher-list \
                                       '' \
                               'm:{a-z}={A-Z}' \
       'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

compctl -/ {c,push,pop}d
compctl -a {,un}alias
compctl -b bindkey
compctl -c exec
compctl -c man
compctl -c sudo
compctl -c {where,which}
compctl -E printenv
compctl -E {,un}setenv
compctl -g '*.(ps|eps)' gv
compctl -j fg
compctl -j kill
compctl -o {,un}setopt
compctl -u chown
compctl -v export
compctl -v unset
compctl -v vared

compctl -x 'p[1,1] S[]' -k "(czf tzf xzf)" \
 - 'p[2,2] C[-1,[tx]zf]' -g '*.(tar.gz|tgz) *(-/)' \
 - 'p[2,2] C[-1,[tx]f]' -g '*.tar *(-/)' \
 - 'p[2,2] c[-1,czf]' -g '*(-/)' -S '.tar.gz ' \
 - 'p[2,2] c[-1,cf]' -g '*(-/)' -S '.tar ' \
 - 'p[3,3] C[-2,c*f]' -g '*(-/)' -- \
 + tar

#====================================================================
# Key Bind
# http://aquahill.net/zsh/dot.zshrc
#====================================================================
#bindkey -e     #EDITOR=emacs
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

#eval `dircolors`
#zstyle ':completion:*' list-colors di=34 fi=0
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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

#====================================================================
# zsh function
#====================================================================

#====================================================================
# exec `ls` when change directory
#====================================================================
chpwd() { ls }

#====================================================================
# setting of ssh
#====================================================================
echo "Protocol 1,2" > ~/.ssh/config

#====================================================================
# Copy ssh public key to remote host
# Usage:
# % addkey hoge.com
#====================================================================
addkey() {
       cat ~/.ssh/authorized.pub | ssh $1 '
       if [ ! -f ~/.ssh/authorized_keys ] ; then
               echo "add_key"
               mkdir -m 700 ~/.ssh
               touch ~/.ssh/authorized_keys
               chmod 600 ~/.ssh/authoorized_keys
       fi
       cat >> ~/.ssh/authorized_keys
       echo "public key registed."
       '
}

#====================================================================
# Copy .zshrc to Server
# if already exists, backup .zshrc with YYYYmmdd.bak filename
# usage: cpzrc <TARGET_SERVER>
#====================================================================
cpzshrc() {
       cat ~/.zshrc | ssh $1 '
       if [ -f ~/.zshrc ] ; then
               cp ~/.zshrc ~/.zshrc.`date +%Y%m%d`.bak
       fi
       cat > ~/.zshrc
       '
}

#====================================================================
# Copy .zshrc to All Server
# usage: cpzrcall
#====================================================================
cpzshrcall() {
       echo "get host from .ssh/known_hosts"
       for rserver in $hosts ; do
               cpzshrc $rserver
               echo "cp .zshrc to $rserver"
       done
}

#====================================================================
#Setting X Display
#====================================================================
function disp () {
 export DISPLAY="$*:0.0"
}

#====================================================================
#Setting CVS Commands
#====================================================================
cvscmds=(add admin annotate checkout commit diff edit editors export help history import init log login logout rdiff release remove rtag status tag unedit update watch watchers)
compctl -x 'p[1,1]' -k cvscmds \
   - 'c[-1,-H]' -k cvscmds -- \
   + cvs

## some CVS functions

function cvsd () { cvs diff -N $* |& $PAGER }
function cvsl () { cvs log $* |& $PAGER }
function cvsr () { rcs2log $* | $PAGER }
function cvss () { cvs status -v $* }
function cvsq () { cvs -nq update }
function cvsa () { cvs add $* && cvs com -m 'initial checkin' $* }

#====================================================================
#`Command` | grep
#
# Usage:
# % lsgrep              #ls | grep
# % psgrep apache       #ps aux | grep
#
# http://aquahill.net/zsh/functions
#====================================================================
function lsgrep () {
       ls -1 | grep $* | xargs ls -la
}

function psgrep () {
 case $SYSTEM {
 sun)
   echo "USER       PID %CPU %MEM   SZ  RSS TT STAT START  TIME COMMAND"
   ps auxw | grep $* ;;
 sol)
   echo "USER       PID %CPU %MEM   SZ  RSS TT       S    START  TIME COMMAND"
   \ps -auwx | grep $* ;;
 sgi)
   echo "     UID   PID  PPID  C    STIME TTY     TIME CMD"
   ps -ef | grep $* ;;
 gnu)
   echo "USER       PID %CPU %MEM  SIZE   RSS TTY STAT START   TIME COMMAND"
   ps auxw | grep -v grep | grep $* ;;
 bsd)
   echo "USER       PID %CPU %MEM   VSZ  RSS  TT  STAT STARTED       TIME COMMAND"
   ps -auxww | grep -v grep | grep $* ;;
 *)
   ps auxw | grep $* ;;
 }
}
#psgrepの別の実装
#function psgrep() {
#    psa | head -n 1             # ラベルを表示
#    psa | grep $* | grep -v "ps -auxww" | grep -v grep # grep プロセスを除外
#}


#====================================================================
#remotestat -- check whether the specified remote port is open or not
# % remotestat 192.168.0.1 80
# http://aquahill.net/zsh/functions
#====================================================================
function remotestat() {
       case $# in
               2) nmap -sT -p $2 $1 | egrep "^$2/" ;;
               *) echo "usage: $0 <host> <port>" 1>&2;
       esac
}

#====================================================================
#Search File
#
# http://aquahill.net/zsh/functions
#====================================================================
function search_file() {
       regex=$1
       case $# in
               1) dir='.' ;;
               2) dir=$2 ;;
               *) echo "usage: $0 <pattern> <dir>" >& 2
                       return ;;
       esac

       find ${dir} -type f | perl -lne "print if /${regex}/" 2>/dev/null
}

#====================================================================
# Book Mark Function
#
# Usage:
# % bmadd       #add directory to bookmark list
# % bmls        #show list of bookmark list
# % bmvi        #edit bookmark list
# % bm $NUMBER  #change directory to $NUMBER bookmark
#====================================================================
BMRC=~/.bmrc
touch $BMRC
bmls() { cat $BMRC | sort -n}
bmvi() { vi $BMRC }
bmadd() {
 local bmdir=`pwd`
 local newid=$1
 local bmname=''
 for bmname in `bm_path_list`
 do
   if [ "$bmname" = "$bmdir" ]; then
     echo "$bmdir is already in bm list"
     return
   fi
 done
 if [ -z $newid ]; then
   maxid=`cat $BMRC | cut -f 1 | sort -n -r | head -1`
   if [ "$maxid" -ge 1 ]; then
     newid=`expr 0$maxid + 1`
   else
     newid=1
   fi
 fi
 echo "$newid\t$bmdir" >> $BMRC
}
bm() {
 local num=$1
 local bmdir=`bm_get $num`
 if [ -z "$bmdir" ]; then
   bmls
   [ -z "$num" ] || echo "$num is not in bm list"
   return
 fi
 cd "$bmdir"
}

bm_get() {
 local bmdir=`cat $BMRC | egrep "^${1}[[:space:]]" | cut -f 2`
 echo $bmdir
}

bm_path_list() {
 cut -f 2 < $BMRC
}

#====================================================================
# pskill - kill processes by name
#====================================================================
pskill () {
 local pid
 pid=$(ps -ax | grep $1 | grep -v grep | awk '{ print $1 }')
 echo -n "killing $1 (process $pid)...\n"
 kill -9 $=pid
}

#====================================================================
# archive - archive dirs, ignore Mac OS X cruft
#====================================================================
archive () {
 if [ -d $1 ]; then
   tar --create --verbose --file=$1.tar $1 -X .DS_Store
   gzip $1.tar
 else
   echo "'$1' is not a valid directory"
 fi
}

#====================================================================
# sparc extracts an archive or mounts a diskimage.
#====================================================================
sparc () {
 if [ -f $1 ]; then
   case $1 in
     *.tar.bz2)  tar -jxvf $1        ;;
     *.tar.gz)   tar -zxvf $1        ;;
     *.bz2)      bunzip2 $1          ;;
     *.dmg)      hdiutil mount $1    ;;
     *.gz)       gunzip $1           ;;
     *.tar)      tar -xvf $1         ;;
     *.tbz2)     tar -jxvf $1        ;;
     *.tgz)      tar -zxvf $1        ;;
     *.zip)      unzip $1            ;;
     *.Z)        uncompress $1       ;;
     *)          echo "'$1' cannot be extracted/mounted via smartextract()" ;;
   esac
 else
   echo "'$1' is not a valid file"
 fi
}

#====================================================================
# Show All CommandLine History
#====================================================================
function history-all {
       history -E 1
}

#====================================================================
# quickrename function
#====================================================================
name() {
   newname=$1
   vared -c -p 'rename to: ' newname
   command mv $1 $newname
}

#====================================================================
# 文字コードの変換を行う
#====================================================================
function euc() {                # 文字コードを euc-jp に変換
   for i in $@; do;
       nkf -e -Lu $i >! /tmp/euc.$$ # -Lu :改行を LF にする
       mv -f /tmp/euc.$$ $i
   done;
}
function sjis() {               # 文字コードを shift-jis に変換
   for i in $@; do;
       nkf -s -Lw $i >! /tmp/euc.$$ # -Lu :改行を CRLF にする
       mv -f /tmp/euc.$$ $i
   done;
}

#====================================================================
# Google検索を行う
#====================================================================
function google() {
 local str opt
 if [ $# != 0 ]; then # 引数が存在すれば
   for i in $*; do
     str="$str+$i"
   done
   str=`echo $str | sed 's/^\+//'` #先頭の「+」を削除
   opt='search?num=50&hl=ja&ie=euc-jp&oe=euc-jp&lr=lang_ja'
   opt="${opt}&q=${str}"
 fi
 #w3m http://www.google.co.jp/$opt #引数がなければ $opt は空になる
 mozilla -remote openURL\(http::/www.google.co.jp/$opt\) # 未テスト
}
alias ggl=google

#====================================================================
# Screen用のステータスラインを変更する
#====================================================================
if [ "$TERM" = "screen" ]; then
       chpwd () { echo -n "�_`dirs`�\\" }
       preexec() {
               # see [zsh-workers:13180]
               # http://www.zsh.org/mla/workers/2000/msg03993.html
               emulate -L zsh
               local -a cmd; cmd=(${(z)2})
               case $cmd[1] in
                       fg)
                               if (( $#cmd == 1 )); then
                                       cmd=(builtin jobs -l %+)
                               else
                                       cmd=(builtin jobs -l $cmd[2])
                               fi
                               ;;
                       %*)
                               cmd=(builtin jobs -l $cmd[1])
                               ;;
                       cd)
                               if (( $#cmd == 2)); then
                                       cmd[1]=$cmd[2]
                               fi
                               ;&
                       *)
                               echo -n "�k$cmd[1]:t�\\"
                               return
                               ;;
               esac

               local -A jt; jt=(${(kv)jobtexts})

               $cmd >>(read num rest
                       cmd=(${(z)${(e):-\$jt$num}})
                       echo -n "�k$cmd[1]:t�\\") 2>/dev/null
       }
       chpwd
fi
