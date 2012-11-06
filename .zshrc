# ~tune/.zshrc

export LANG=ja_JP.UTF-8
export HISTFILE=$HOME/.zhistory
export HISTSIZE=100000
export SAVEHIST=100000
export USER=$USERNAME
export HOSTNAME=$HOST


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
## Default shell configuration
# colors enables us to idenfity color by $fg[red].
autoload colors
colors
case ${UID} in
0)
    PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
*)
    #
    # Color
    #
    DEFAULT=$'%{\e[1;0m%}'
    RESET="%{${reset_color}%}"
    GREEN="%{${fg[green]}%}"
    BLUE="%{${fg[blue]}%}"
    RED="%{${fg[red]}%}"
    CYAN="%{${fg[cyan]}%}"
    WHITE="%{${fg[white]}%}"

    #
    # Prompt
    #
    PROMPT='%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}$ ${RESET}'
    RPROMPT='${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${RESET}'

    #
    # Vi入力モードでPROMPTの色を変える
    # http://memo.officebrook.net/20090226.html
    function zle-line-init zle-keymap-select {
      case $KEYMAP in
        vicmd)
        PROMPT="%{$fg_bold[cyan]%}${USER}@%m ${RESET}${WHITE}$ ${RESET}"
        ;;
        main|viins)
        PROMPT="%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}$ ${RESET}"
        ;;
      esac
      zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-keymap-select

    # Show git branch when you are in git repository
    # http://d.hatena.ne.jp/mollifier/20100906/p1

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git svn hg bzr
    zstyle ':vcs_info:*' formats '(%s)-[%b]'
    zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
    zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
    zstyle ':vcs_info:bzr:*' use-simple true

    autoload -Uz is-at-least
    if is-at-least 4.3.10; then
      # この check-for-changes が今回の設定するところ
      zstyle ':vcs_info:git:*' check-for-changes true
      zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
      zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
      zstyle ':vcs_info:git:*' formats '(%s)-[%c%u%b]'
      zstyle ':vcs_info:git:*' actionformats '(%s)-[%c%u%b|%a]'
    fi

    function _update_vcs_info_msg() {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        psvar[2]=$(_git_not_pushed)
        [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    }
    add-zsh-hook precmd _update_vcs_info_msg

    # show status of git pushed to HEAD in prompt
    function _git_not_pushed()
    {
      if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
        head="$(git rev-parse HEAD)"
        for x in $(git rev-parse --remotes)
        do
          if [ "$head" = "$x" ]; then
            return 0
          fi
        done
        echo "|?"
      fi
      return 0
    }
    
    # ZshでGitのカレントブランチを右プロンプトに表示。
    # コミット済みのきれいな状態だと緑色、未コミットの編集がある場合は赤色で表示される。
    # http://qiita.com/items/325cffc755fc1ff91928
    setopt prompt_subst
    autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
    
    function rprompt-git-current-branch {
      local name st color gitdir action
      if [[ "$PWD" =~ '/¥.git(/.*)?$' ]]; then
        return
      fi
      name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
      if [[ -z $name ]]; then
        return
      fi
    
      gitdir=`git rev-parse --git-dir 2> /dev/null`
      action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"
    
      st=`git status 2> /dev/null`
      if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=%F{green}
      elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=%F{yellow}
      elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
        color=%B%F{red}
      else
         color=%F{red}
      fi
      echo "$color$name$action%f%b "
    }
    
    # -------------- 使い方 ---------------- #
    RPROMPT='`rprompt-git-current-branch`'
    
    ;;
esac

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

## alias設定
[ -f ~/dotfiles/.zshrc.alias ] && source ~/dotfiles/.zshrc.alias

case "${OSTYPE}" in
# Cygwin(Windows)
cygwin*)
    # ここに設定
    [ -f ~/dotfiles/.zshrc.cygwin ] && source ~/dotfiles/.zshrc.cygwin
    ;;
# Mac(Unix)
darwin*)
    # ここに設定
    [ -f ~/dotfiles/.zshrc.osx ] && source ~/dotfiles/.zshrc.osx
    ;;
# Linux
linux*)
    # ここに設定
    [ -f ~/dotfiles/.zshrc.linux ] && source ~/dotfiles/.zshrc.linux
    ;;
esac


## local固有設定
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
