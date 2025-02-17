#!/bin/bash

# include guard
ble/is-function ble-edit/bind/load-editing-mode:emacs && return 0
function ble-edit/bind/load-editing-mode:emacs { :; }

# 2015-12-09 keymap cache should be updated due to the refactoring.
# 2019-01-18 keymap cache should be updated for recent changes
# 2019-03-21 keymap cache should be updated for recent changes
# 2020-04-29 force update (rename ble-decode/keymap/.register)
# 2021-01-25 force update (change mapping of C-w and M-w)
# 2021-04-26 force update (rename ble/decode/keymap#.register)

#------------------------------------------------------------------------------

_ble_keymap_emacs_white_list=(
  self-insert
  batch-insert
  nop
  magic-space
  copy{,-forward,-backward}-{c,f,s,u}word
  copy-region{,-or}
  clear-screen
  command-help
  display-shell-version
  redraw-line
  # delete-backward-{c,f,s,u}word
  # delete-bacward-char
)
function ble/keymap:emacs/is-command-white {
  if [[ $1 == ble/widget/self-insert ]]; then
    # frequently used command is checked first
    return 0
  elif [[ $1 == ble/widget/* ]]; then
    local IFS=$_ble_term_IFS
    local cmd=${1#ble/widget/}; cmd=${cmd%%[$' \t\n']*}
    [[ $cmd == emacs/* || " ${_ble_keymap_emacs_white_list[*]} " == *" $cmd "*  ]] && return 0
  fi
  return 1
}

function ble/widget/emacs/__before_widget__ {
  if ! ble/keymap:emacs/is-command-white "$WIDGET"; then
    ble-edit/undo/add
  fi
}

#------------------------------------------------------------------------------
# 注意: ble/widget/emacs/* の名称の編集関数では、
# 必要に応じて手動で ble-edit/undo/add を呼び出さなければならない。

function ble/widget/emacs/undo {
  local arg; ble-edit/content/get-arg 1
  ble-edit/undo/undo "$arg" || ble/widget/.bell 'no more older undo history'
}
function ble/widget/emacs/redo {
  local arg; ble-edit/content/get-arg 1
  ble-edit/undo/redo "$arg" || ble/widget/.bell 'no more recent undo history'
}
function ble/widget/emacs/revert {
  local arg; ble-edit/content/clear-arg
  ble-edit/undo/revert
}

#------------------------------------------------------------------------------
# mode name
#
#   mode name の更新は基本的に __after_widget__ で行う。
#   但し、_ble_decode_{char,key}__hook 経由で実行されると、
#   __after_widget__ は実行されないので、
#   その様な編集コマンドについてだけは個別に update-mode-name を呼び出す。
#

## @var _ble_keymap_emacs_mode
##   複数行モードかどうか。
_ble_keymap_emacs_modeline=::
ble/array#push _ble_textarea_local_VARNAMES \
               _ble_keymap_emacs_modeline
function ble/keymap:emacs/update-mode-name {
  local opt_multiline=; [[ $_ble_edit_str == *$'\n'* ]] && opt_multiline=1
  local footprint=$opt_multiline:$_ble_edit_arg:$_ble_edit_kbdmacro_record

  [[ $footprint == "$_ble_keymap_emacs_modeline" ]] && return 0
  _ble_keymap_emacs_modeline=$footprint

  local name=
  [[ $opt_multiline ]] && name=$'\e[1m-- MULTILINE --\e[m'

  local info=
  [[ $_ble_edit_arg ]] &&
    info=$info$' (arg: \e[1;34m'$_ble_edit_arg$'\e[m)'
  [[ $_ble_edit_kbdmacro_record ]] &&
    info=$info$' \e[1;31mREC\e[m'
  [[ ! $info && $opt_multiline ]] &&
    info=$' (\e[35mRET\e[m or \e[35mC-m\e[m: insert a newline, \e[35mC-j\e[m: run)'

  [[ $name ]] || info=${info#' '}
  name=$name$info
  ble/edit/info/default ansi "$name"
}

function ble/widget/emacs/__after_widget__ {
  ble/keymap:emacs/update-mode-name
}

# quoted-insert
function ble/widget/emacs/quoted-insert-char {
  _ble_edit_mark_active=
  _ble_decode_char__hook=ble/widget/emacs/quoted-insert-char.hook
  return 147
}
function ble/widget/emacs/quoted-insert-char.hook {
  ble/widget/quoted-insert-char.hook
  ble/keymap:emacs/update-mode-name
}
function ble/widget/emacs/quoted-insert {
  _ble_edit_mark_active=
  _ble_decode_key__hook=ble/widget/emacs/quoted-insert.hook
  return 147
}
function ble/widget/emacs/quoted-insert.hook {
  ble/widget/quoted-insert.hook
  ble/keymap:emacs/update-mode-name
}

function ble/widget/emacs/bracketed-paste {
  ble/widget/bracketed-paste
  _ble_edit_bracketed_paste_proc=ble/widget/emacs/bracketed-paste.proc
  return 147
}
function ble/widget/emacs/bracketed-paste.proc {
  ble/widget/bracketed-paste.proc "$@"
  ble/keymap:emacs/update-mode-name
}

#------------------------------------------------------------------------------

function ble-decode/keymap:emacs/define {
  #----------------------------------------------------------------------------
  # common bindings + modifications

  local ble_bind_nometa=
  ble-decode/keymap:safe/bind-common
  ble-decode/keymap:safe/bind-history
  ble-decode/keymap:safe/bind-complete
  ble-decode/keymap:safe/bind-arg

  # charwise operations
  ble-bind -f 'C-d'      'delete-region-or delete-forward-char-or-exit'

  # history
  ble-bind -f 'M-^'      history-expand-line
  ble-bind -f 'SP'       magic-space

  #----------------------------------------------------------------------------

  ble-bind -f __attach__        safe/__attach__
  ble-bind -f __before_widget__ emacs/__before_widget__
  ble-bind -f __after_widget__  emacs/__after_widget__
  ble-bind -f __line_limit__    __line_limit__

  # accept/cancel
  ble-bind -f 'C-c'      discard-line
  ble-bind -f 'C-j'      accept-line
  ble-bind -f 'C-RET'    accept-line
  ble-bind -f 'C-m'      accept-single-line-or-newline
  ble-bind -f 'RET'      accept-single-line-or-newline
  ble-bind -f 'C-o'      accept-and-next
  ble-bind -f 'C-x C-e'  edit-and-execute-command
  ble-bind -f 'M-#'      insert-comment
  ble-bind -f 'M-C-e'    shell-expand-line
  ble-bind -f 'M-&'      tilde-expand
  ble-bind -f 'C-g'      bell
  ble-bind -f 'C-x C-g'  bell
  ble-bind -f 'C-M-g'    bell

  # shell functions
  ble-bind -f 'C-l'      clear-screen
  ble-bind -f 'C-M-l'    redraw-line
  ble-bind -f 'f1'       command-help
  ble-bind -f 'C-x C-v'  display-shell-version
  ble-bind -c 'C-z'      fg
  ble-bind -c 'M-z'      fg

  ble-bind -f 'C-\'      bell
  ble-bind -f 'C-^'      bell

  #----------------------------------------------------------------------------

  # undo
  ble-bind -f 'C-_'       emacs/undo
  ble-bind -f 'C-DEL'     emacs/undo
  ble-bind -f 'C-BS'      emacs/undo
  ble-bind -f 'C-/'       emacs/undo
  ble-bind -f 'C-x u'     emacs/undo
  ble-bind -f 'C-x C-u'   emacs/undo
  ble-bind -f 'C-x U'     emacs/redo
  ble-bind -f 'C-x C-S-u' emacs/redo
  ble-bind -f 'M-r'       emacs/revert

  # mode name
  ble-bind -f 'C-q'       emacs/quoted-insert
  ble-bind -f 'C-v'       emacs/quoted-insert
  ble-bind -f paste_begin emacs/bracketed-paste
}

function ble-decode/keymap:emacs/initialize {
  local fname_keymap_cache=$_ble_base_cache/keymap.emacs
  if [[ $fname_keymap_cache -nt $_ble_base/keymap/emacs.sh &&
          $fname_keymap_cache -nt $_ble_base/lib/init-cmap.sh ]]; then
    source "$fname_keymap_cache" && return 0
  fi

  ble/edit/info/immediate-show text "ble.sh: updating cache/keymap.emacs..."

  {
    ble/decode/keymap#load isearch dump
    ble/decode/keymap#load nsearch dump
    ble/decode/keymap#load emacs   dump
  } 3>| "$fname_keymap_cache"

  ble/edit/info/immediate-show text "ble.sh: updating cache/keymap.emacs... done"
}

ble-decode/keymap:emacs/initialize
blehook/invoke keymap_load
blehook/invoke keymap_emacs_load
return 0
