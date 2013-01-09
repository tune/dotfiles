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

# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

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
		# Prompt
		#
		PROMPT='%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}'
		RPROMPT='${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${RESET}'

		#
		# Vi入力モードでPROMPTの色を変える
		# http://memo.officebrook.net/20090226.html
		function zle-line-init zle-keymap-select {
			case $KEYMAP in
				vicmd)
				PROMPT="%{$fg_bold[cyan]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}"
				;;
			main|viins)
			PROMPT="%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}"
			;;
			esac
			zle reset-prompt
		}
		zle -N zle-line-init
		zle -N zle-keymap-select

		# http://qiita.com/items/8d5a627d773758dd8078
		# vcs_info 設定

		RPROMPT=""

		autoload -Uz vcs_info
		autoload -Uz add-zsh-hook
		autoload -Uz is-at-least
		autoload -Uz colors

		# 以下の3つのメッセージをエクスポートする
		#   $vcs_info_msg_0_ : 通常メッセージ用 (緑)
		#   $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
		#   $vcs_info_msg_2_ : エラーメッセージ用 (赤)
		zstyle ':vcs_info:*' max-exports 3

		zstyle ':vcs_info:*' enable git svn hg bzr
		# 標準のフォーマット(git 以外で使用)
		# misc(%m) は通常は空文字列に置き換えられる
		zstyle ':vcs_info:*' formats '(%s)-[%b]'
		zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
		zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
		zstyle ':vcs_info:bzr:*' use-simple true


		if is-at-least 4.3.10; then
			# git 用のフォーマット
			# git のときはステージしているかどうかを表示
			zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
			zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
			zstyle ':vcs_info:git:*' check-for-changes true
			zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
			zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列
		fi

		# hooks 設定
		if is-at-least 4.3.11; then
			# git のときはフック関数を設定する

			# formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
			# のメッセージを設定する直前のフック関数
			# 今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので
			# 各関数が最大3回呼び出される。
			zstyle ':vcs_info:git+set-message:*' hooks \
				git-hook-begin \
				git-untracked \
				git-push-status \
				git-nomerge-branch \
				git-stash-count

			# フックの最初の関数
			# git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
			# (.git ディレクトリ内にいるときは呼び出さない)
			# .git ディレクトリ内では git status --porcelain などがエラーになるため
			function +vi-git-hook-begin() {
			if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
				# 0以外を返すとそれ以降のフック関数は呼び出されない
				return 1
			fi

			return 0
		}

		# untracked ファイル表示
		#
		# untracked ファイル(バージョン管理されていないファイル)がある場合は
		# unstaged (%u) に ? を表示
		function +vi-git-untracked() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			if command git status --porcelain 2> /dev/null \
				| awk '{print $1}' \
				| command grep -F '??' > /dev/null 2>&1 ; then

				# unstaged (%u) に追加
				hook_com[unstaged]+='?'
				fi
		}

		# push していないコミットの件数表示
		#
		# リモートリポジトリに push していないコミットの件数を
		# pN という形式で misc (%m) に表示する
		function +vi-git-push-status() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			if [[ "${hook_com[branch]}" != "master" ]]; then
				# master ブランチでない場合は何もしない
				return 0
			fi

			# push していないコミット数を取得する
			local ahead
			ahead=$(command git rev-list origin/master..master 2>/dev/null \
				| wc -l \
				| tr -d ' ')

			if [[ "$ahead" -gt 0 ]]; then
				# misc (%m) に追加
				hook_com[misc]+="(p${ahead})"
			fi
		}

		# マージしていない件数表示
		#
		# master 以外のブランチにいる場合に、
		# 現在のブランチ上でまだ master にマージしていないコミットの件数を
		# (mN) という形式で misc (%m) に表示
		function +vi-git-nomerge-branch() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			if [[ "${hook_com[branch]}" == "master" ]]; then
				# master ブランチの場合は何もしない
				return 0
			fi

			local nomerged
			nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

			if [[ "$nomerged" -gt 0 ]] ; then
				# misc (%m) に追加
				hook_com[misc]+="(m${nomerged})"
			fi
		}


		# stash 件数表示
		#
		# stash している場合は :SN という形式で misc (%m) に表示
		function +vi-git-stash-count() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			local stash
			stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
			if [[ "${stash}" -gt 0 ]]; then
				# misc (%m) に追加
				hook_com[misc]+=":S${stash}"
			fi
		}

	fi

	function _update_vcs_info_msg() {
		local -a messages
		local prompt

		LANG=en_US.UTF-8 vcs_info

		if [[ -z ${vcs_info_msg_0_} ]]; then
			# vcs_info で何も取得していない場合はプロンプトを表示しない
			prompt=""
		else
			# vcs_info で情報を取得した場合
			# $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
			# それぞれ緑、黄色、赤で表示する
			[[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
			[[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
			[[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

			# 間にスペースを入れて連結する
			prompt="${(j: :)messages}"
		fi

		RPROMPT="$prompt"
	}
add-zsh-hook precmd _update_vcs_info_msg

;;
esac

#====================================================================
# Completion
#====================================================================
# zsh-completionsを利用する Github => zsh-completions
fpath=(~/dotfiles/zsh/zsh-completions $fpath)

autoload -U compinit; compinit
zstyle ':completion:*:default' menu select=2

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
	/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# 大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..

# known_hosts補完
function print_known_hosts (){ 
if [ -f $HOME/.ssh/known_hosts ]; then
	cat $HOME/.ssh/known_hosts | tr ',' ' ' | cut -d' ' -f1 
fi
}
_cache_hosts=($( print_known_hosts ))

# よく移動するディレクトリをcdrで表示
# http://qiita.com/items/c5f44ad6dcae059ea34c
zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

typeset -ga chpwd_functions

if is-at-least 4.3.11; then
	autoload -U chpwd_recent_dirs cdr
	chpwd_functions+=chpwd_recent_dirs
	zstyle ":chpwd:*" recent-dirs-max 500
	zstyle ":chpwd:*" recent-dirs-default true
	zstyle ":completion:*" recent-dirs-insert always
fi

# 補完に関するオプション
# http://voidy21.hatenablog.jp/entry/20090902/1251918174
setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt interactive_comments  # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示

setopt print_eight_bit  #日本語ファイル名等8ビットを通す
setopt extended_glob  # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ

bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)

# 範囲指定できるようにする
# 例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt brace_ccl

# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true

# 変数の添字を補完する
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# apt-getとかdpkgコマンドをキャッシュを使って速くする
zstyle ':completion:*' use-cache true

# ディレクトリを切り替える時の色々な補完スタイル
#あらかじめcdpathを適当に設定しておく
cdpath=(~ ~/myapp/gae/ ~/myapp/gae/google_appengine/demos/)
# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補に出す
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
#cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする (例: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# オブジェクトファイルとか中間ファイルとかはfileとして補完させない
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

# gitignore-boilerplates`
if [ -f ~/dotfiles/bin/gitignore-boilerplates/gibo-completion.zsh ]; then
	source ~/dotfiles/bin/gitignore-boilerplates/gibo-completion.zsh
fi

# mosh
compdef mosh=ssh

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
bindkey '^R' history-incremental-search-backward

#====================================================================
# Set Option
# See man zshoptions(1)
#====================================================================
#Do not exit on end-of-file
setopt ignore_eof

# zshのextended_globとHEAD^を共存させる
# http://subtech.g.hatena.ne.jp/cho45/20080617/1213629154
typeset -A abbreviations
abbreviations=(
"L"    "| $PAGER"
"G"    "| grep"

"HEAD^"     "HEAD\\^"
"HEAD^^"    "HEAD\\^\\^"
"HEAD^^^"   "HEAD\\^\\^\\^"
"HEAD^^^^"  "HEAD\\^\\^\\^\\^\\^"
"HEAD^^^^^" "HEAD\\^\\^\\^\\^\\^"
)

magic-abbrev-expand () {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9^]#}
	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
}

magic-abbrev-expand-and-insert () {
	magic-abbrev-expand
	zle self-insert
}

magic-abbrev-expand-and-accept () {
	magic-abbrev-expand
	zle accept-line
}

no-magic-abbrev-expand () {
	LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-accept
zle -N no-magic-abbrev-expand
bindkey "\r"  magic-abbrev-expand-and-accept # M-x RET はできなくなる
bindkey "^J"  accept-line # no magic
bindkey " "   magic-abbrev-expand-and-insert
bindkey "."   magic-abbrev-expand-and-insert
bindkey "^x " no-magic-abbrev-expand

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
setopt auto_list                #Default Enable
setopt auto_remove_slash        #Dafault Enable

#about List
setopt list_packed

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
setopt chase_links
setopt notify
setopt numeric_glob_sort
setopt prompt_subst
setopt sh_word_split
setopt sun_keyboard_hack
setopt glob_dots
setopt long_list_jobs
setopt equals
#setopt xtrace


#=============================
# source zsh-syntax-highlighting
#=============================
if [ -f ~/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source ~/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


# コマンドラインからWeb検索
# http://qiita.com/items/55651f44f91123f1881c
# url: $1, delimiter: $2, prefix: $3, words: $4..
function web_search {
local url=$1       && shift
local delimiter=$1 && shift
local prefix=$1    && shift
local query

while [ -n "$1" ]; do
	if [ -n "$query" ]; then
		query="${query}${delimiter}${prefix}$1"
	else
		query="${prefix}$1"
	fi
	shift
done

open "${url}${query}"
}

function qiita () {
web_search "http://qiita.com/search?utf8=✓&q=" "+" "" $*
}

function google () {
web_search "https://www.google.co.jp/search?&q=" "+" "" $*
}

# search in rurima
function rurima () {
web_search "http://rurema.clear-code.com" "/" "query:" $*
}

# search in rubygems
function gems () {
web_search "http://rubygems.org/search?utf8=✓&query=" "+" "" $*
}

# search in github
function github () {
web_search "https://github.com/search?type=Code&q=" "+" "" $*
}

# alias設定
[ -f ~/dotfiles/.zshrc.alias ] && source ~/dotfiles/.zshrc.alias

# z
[ -f ~/dotfiles/zsh/z/z.sh ] && source ~/dotfiles/zsh/z/zsh

# OS毎の設定
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

