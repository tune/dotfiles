# ~tune/.zshenv

#====================================================================
# Settig Environment Variable
#====================================================================
# 重複したパスを登録しない。
typeset -U path

# (N-/): 存在しないディレクトリは登録しない。
#    パス(...): ...という条件にマッチするパスのみ残す。
#            N: NULL_GLOBオプションを設定。
#               globがマッチしなかったり存在しないパスを無視する。
#            -: シンボリックリンク先のパスを評価。
#            /: ディレクトリのみ残す。
path=(
       /bin(N-/)
       /usr/bin(N-/)
       /usr/local/bin(N-/)
       /usr/X11R6/bin(N-/)
       /opt/local/bin(N-/)
       $HOME/dotfiles/bin/*(N-/)
)

# sudo時のパスの設定
# -x: export SUDO_PATHも一緒に行う。
# -T: SUDO_PATHとsudo_pathを連動する。
typeset -xT SUDO_PATH sudo_path

# 重複したパスを登録しない。
typeset -U sudo_path

# (N-/): 存在しないディレクトリは登録しない。
#    パス(...): ...という条件にマッチするパスのみ残す。
#            N: NULL_GLOBオプションを設定。
#               globがマッチしなかったり存在しないパスを無視する。
#            -: シンボリックリンク先のパスを評価。
#            /: ディレクトリのみ残す。
sudo_path=(
       /sbin(N-/)
       /usr/sbin(N-/)
       /usr/local/sbin(N-/)
       /opt/local/sbin(N-/)
)
export MANPATH=/opt/local/man:$MANPATH

# ページャの設定
if type lv > /dev/null 2>&1; then
    ## lvを優先する。
    export PAGER="lv"
else
    ## lvがなかったらlessを使う。
    export PAGER="less"
fi

# lvの設定
## -c: ANSIエスケープシーケンスの色付けなどを有効にする。
## -l: 1行が長くと折り返されていても1行として扱う。
##     （コピーしたときに余計な改行を入れない。）
export LV="-c -l"

if [ "$PAGER" != "lv" ]; then
    ## lvがなくてもlvでページャーを起動する。
    alias lv="$PAGER"
fi

# lessの設定
## -R: ANSIエスケープシーケンスのみ素通しする。
## 2012-09-04
export LESS="-R"
export EDITOR=vim
## vimがなくてもvimでviを起動する。
if ! type vim > /dev/null 2>&1; then
    alias vim=vi
fi
