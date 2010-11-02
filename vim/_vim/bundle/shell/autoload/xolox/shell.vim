" Vim auto-load script
" Author: Peter Odding <peter@peterodding.com>
" Last Change: September 19, 2010
" URL: http://peterodding.com/code/vim/shell/

if !exists('s:script')
  let s:script = expand('<sfile>:p:~')
  let s:enoimpl = "%s() hasn't been implemented on your platform! %s"
  let s:contact = "If you have suggestions, please contact the vim_dev mailing-list or peter@peterodding.com."
  let s:fullscreen_enabled = 0
endif

function! xolox#shell#open_cmd(arg) " -- implementation of the :Open command {{{1
  if a:arg !~ '\S'
    if !s:open_at_cursor()
      call xolox#open#file(expand('%:p:h'))
    endif
  elseif a:arg =~ g:shell_patt_url || a:arg =~ g:shell_patt_mail
    call xolox#open#url(a:arg)
  else
    let arg = fnamemodify(a:arg, ':p')
    if isdirectory(arg) || filereadable(arg)
      call xolox#open#file(arg)
    else
      let msg = "%s: I don't know how to open %s!"
      echoerr printf(msg, s:script, string(a:arg))
    endif
  endif
endfunction

function! s:open_at_cursor()
  let cWORD = expand('<cWORD>')
  " Start by trying to match a URL in <cWORD> because URLs can be more-or-less
  " unambiguously distinguished from e-mail addresses and filenames.
  let match = matchstr(cWORD, g:shell_patt_url)
  if match == ''
    " Now try to match an e-mail address in <cWORD> because most filenames
    " won't contain an @-sign while e-mail addresses require it.
    let match = matchstr(cWORD, g:shell_patt_mail)
  endif
  if match != ''
    call xolox#open#url(match)
    return 1
  else
    " As a last resort try to match a filename at the text cursor position.
    let line = getline('.')
    let idx = col('.') - 1
    let match = matchstr(line[0 : idx], '\f*$')
    let match .= matchstr(line[idx+1 : -1], '^\f*')
    " Expand leading tilde and/or environment variables in filename?
    if match =~ '^\~' || match =~ '\$'
      let match = split(expand(match), "\n")[0]
    endif
    if match != '' && (isdirectory(match) || filereadable(match))
      call xolox#open#file(match)
      return 1
    endif
  endif
endfunction

function! xolox#shell#open_with_windows_shell(location)
  if xolox#is_windows() && s:has_dll()
    let error = s:library_call('openurl', a:location)
    if error != ''
      let msg = '%s: Failed to open %s with Windows shell! (error: %s)'
      throw printf(msg, s:script, string(a:location), strtrans(xolox#trim(error)))
    endif
  endif
endfunction

function! xolox#shell#highlight_urls() " -- highlight URLs and e-mail addresses embedded in source code comments {{{1
  if exists('g:syntax_on') && &ft !~ g:shell_hl_exclude
    if &ft == 'help'
      let command = 'syntax match %s /%s/'
      let urlgroup = 'HelpURL'
      let mailgroup = 'HelpEmail'
    else
      let command = 'syntax match %s /%s/ contained containedin=.*Comment.*'
      let urlgroup = 'CommentURL'
      let mailgroup = 'CommentEmail'
    endif
    execute printf(command, urlgroup, escape(g:shell_patt_url, '/'))
    execute printf(command, mailgroup, escape(g:shell_patt_mail, '/'))
    execute 'highlight def link' urlgroup 'Underlined'
    execute 'highlight def link' mailgroup 'Underlined'
  endif
endfunction

function! xolox#shell#execute(command, synchronous, ...) " -- execute external commands asynchronously {{{1
  try
    let cmd = a:command
    let has_input = a:0 > 0
    if has_input
      let tempin = tempname()
      call writefile(type(a:1) == type([]) ? a:1 : split(a:1, "\n"), tempin)
      let cmd .= ' < ' . shellescape(tempin)
    endif
    if a:synchronous
      let tempout = tempname()
      let cmd .= ' > ' . shellescape(tempout) . ' 2>&1'
    endif
    if xolox#is_windows() && s:has_dll()
      let fn = 'execute_' . (a:synchronous ? '' : 'a') . 'synchronous'
      let cmd = ($COMSPEC != '' ? $COMSPEC : 'CMD.EXE') . ' /C ' . cmd
      let error = s:library_call(fn, cmd)
      if error != ''
        let msg = '%s: %s(%s) failed! (error: %s)'
        throw printf(msg, s:script, fn, strtrans(cmd), strtrans(error))
      endif
    else
      if has('unix') && !a:synchronous
        let cmd = '(' . cmd . ') &'
      endif
      call s:handle_error(cmd, system(cmd))
    endif
    if a:synchronous
      if !filereadable(tempout)
        let msg = '%s: Failed to execute %s!'
        throw printf(msg, s:script, strtrans(cmd))
      endif
      return readfile(tempout)
    else
      return 1
    endif
  catch
    call xolox#warning("%s: %s at %s", s:script, v:exception, v:throwpoint)
  finally
    if exists('tempin') | call delete(tempin) | endif
    if exists('tempout') | call delete(tempout) | endif
  endtry
endfunction

function! xolox#shell#fullscreen() " -- toggle Vim between normal and full-screen mode {{{1

  " TODO Wrap in try/catch block with xolox#warning() feedback?

  " On entering full-screen hide GUI components like the main menu, tool bar
  " and tab line. Remember which components were actually hidden and should be
  " restored when leaving full-screen later.
  if !s:fullscreen_enabled
    let s:go_toggled = ''
    for item in split(g:shell_fullscreen_items, '.\zs')
      if &go =~# item
        let s:go_toggled .= item
        execute 'set go-=' . item
      endif
    endfor
    if g:shell_fullscreen_items =~# 'e' && &stal != 0
      let s:stal_save = &stal
      set showtabline=0
    endif
  endif

  " Now try to toggle the real full-screen status of Vim's GUI window using a
  " custom dynamic link library on Windows or the "wmctrl" program on UNIX.
  try
    if xolox#is_windows() && s:has_dll()
      let error = s:library_call('fullscreen', !s:fullscreen_enabled)
      if error != ''
        throw "shell.dll failed with: " . error
      endif
    elseif has('unix')
      if !executable('wmctrl')
        let msg = "Full-screen on UNIX requires the `wmctrl' program!"
        throw msg . " On Debian/Ubuntu you can install it by executing `sudo apt-get install wmctrl'."
      endif
      let command = 'wmctrl -r :ACTIVE: -b toggle,fullscreen 2>&1'
      call s:handle_error(command, system(command))
    else
      throw printf(s:enoimpl, 'fullscreen', s:contact)
    endif
  catch
    call xolox#warning("%s: %s at %s", s:script, v:exception, v:throwpoint)
  endtry

  " On leaving full-screen restore display of previously hidden GUI components?
  if s:fullscreen_enabled
    let &go .= s:go_toggled
    if exists('s:stal_save')
      let &stal = s:stal_save
      unlet s:stal_save
    endif
  endif

  " Toggle the boolean status returned by xolox#shell#is_fullscreen().
  let s:fullscreen_enabled = !s:fullscreen_enabled

  " Let the user know how to leave full-screen mode?
  if s:fullscreen_enabled
    sleep 50 m
    call xolox#message("To return from full-screen type <F11> or execute :Fullscreen.")
  endif

endfunction

function! xolox#shell#is_fullscreen() " -- check whether Vim is currently in full-screen mode {{{1
  return s:fullscreen_enabled
endfunction

" Miscellaneous script-local functions. {{{1

if xolox#is_windows()

  let s:library = expand('<sfile>:p:h') . '\shell.dll'

  function! s:library_call(fn, arg) " {{{2
    return libcall(s:library, a:fn, a:arg)
  endfunction

  function! s:has_dll() " {{{2
    try
      return s:library_call('libversion', '') == '0.2'
    catch
      return 0
    endtry
  endfunction

endif

function! s:handle_error(cmd, output) " {{{2
  if v:shell_error
    let msg = "Command %s failed!"
    if a:output =~ '^\_s*$'
      throw printf(msg, string(a:cmd))
    else
      let msg .= ' (output: %s)'
      let output = strtrans(xolox#trim(a:output))
      throw printf(msg, string(a:cmd), )
    endif
  endif
endfunction

" vim: ts=2 sw=2 et fdm=marker
