# ~tune/.zshenv

#====================================================================
# Settig Environment Variable
#====================================================================
# �d�������p�X��o�^���Ȃ��B
typeset -U path

# (N-/): ���݂��Ȃ��f�B���N�g���͓o�^���Ȃ��B
#    �p�X(...): ...�Ƃ��������Ƀ}�b�`����p�X�̂ݎc���B
#            N: NULL_GLOB�I�v�V������ݒ�B
#               glob���}�b�`���Ȃ������葶�݂��Ȃ��p�X�𖳎�����B
#            -: �V���{���b�N�����N��̃p�X��]���B
#            /: �f�B���N�g���̂ݎc���B
path=(
       /bin(N-/)
       /usr/bin(N-/)
       /usr/local/bin(N-/)
       /usr/X11R6/bin(N-/)
       /opt/local/bin(N-/)
       $HOME/dotfiles/bin/*(N-/)
)

# sudo���̃p�X�̐ݒ�
# -x: export SUDO_PATH���ꏏ�ɍs���B
# -T: SUDO_PATH��sudo_path��A������B
typeset -xT SUDO_PATH sudo_path

# �d�������p�X��o�^���Ȃ��B
typeset -U sudo_path

# (N-/): ���݂��Ȃ��f�B���N�g���͓o�^���Ȃ��B
#    �p�X(...): ...�Ƃ��������Ƀ}�b�`����p�X�̂ݎc���B
#            N: NULL_GLOB�I�v�V������ݒ�B
#               glob���}�b�`���Ȃ������葶�݂��Ȃ��p�X�𖳎�����B
#            -: �V���{���b�N�����N��̃p�X��]���B
#            /: �f�B���N�g���̂ݎc���B
sudo_path=(
       /sbin(N-/)
       /usr/sbin(N-/)
       /usr/local/sbin(N-/)
       /opt/local/sbin(N-/)
)
export MANPATH=/opt/local/man:$MANPATH

# �y�[�W���̐ݒ�
if type lv > /dev/null 2>&1; then
    ## lv��D�悷��B
    export PAGER="lv"
else
    ## lv���Ȃ�������less���g���B
    export PAGER="less"
fi

# lv�̐ݒ�
## -c: ANSI�G�X�P�[�v�V�[�P���X�̐F�t���Ȃǂ�L���ɂ���B
## -l: 1�s�������Ɛ܂�Ԃ���Ă��Ă�1�s�Ƃ��Ĉ����B
##     �i�R�s�[�����Ƃ��ɗ]�v�ȉ��s�����Ȃ��B�j
export LV="-c -l"

if [ "$PAGER" != "lv" ]; then
    ## lv���Ȃ��Ă�lv�Ńy�[�W���[���N������B
    alias lv="$PAGER"
fi

# less�̐ݒ�
## -R: ANSI�G�X�P�[�v�V�[�P���X�̂ݑf�ʂ�����B
## 2012-09-04
export LESS="-R"
export EDITOR=vim
## vim���Ȃ��Ă�vim��vi���N������B
if ! type vim > /dev/null 2>&1; then
    alias vim=vi
fi
