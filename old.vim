"===========================================================================
" ventana stuff
"===========================================================================

"let w:ventana_window_name = 'main'
"
"function! FocusAuxiliaryWindow()
"  let l:window_id = GetWindowIDFromName('auxiliary')
"  if l:window_id == 0
"    wincmd n
"    wincmd L
"    let w:ventana_window_name = 'auxiliary'
"  else
"    execute l:window_id .. 'wincmd w'
"  endif
"endfunction
"
"function! FocusMainWindow()
"  let l:window_id = GetWindowIDFromName('main')
"  if l:window_id == 0
"    echoerr 'could not find window main'
"  else
"    execute l:window_id .. 'wincmd w'
"  endif
"endfunction
"
"function! FocusTerminal()
"  call FocusAuxiliaryWindow()
"  for buf in getbufinfo()
"    if getbufvar(buf.bufnr, 'ventana_buffer_name', '') ==# 'terminal'
"      execute ':buffer ' .. buf.bufnr
"      normal A
"      return
"    endif
"  endfor
"  terminal
"  let w:ventana_buffer_name = 'terminal'
"  setlocal nonumber
"  normal A
"endfunction
"
"function! GetWindowIDFromName(name)
"  for win in getwininfo()
"    if get(win.variables, 'ventana_window_name', '') ==# a:name
"      return win.winnr
"    endif
"  endfor
"  return 0
"endfunction
"
"function! CloseAllWindowsButMain()
"  call FocusMainWindow()
"  for win in getwininfo()
"    if get(win.variables, 'ventana_window_name', '') !=# 'main'
"      execute 'close ' .. win.winnr
"    endif
"  endfor
"endfunction
"
"function! CloseAllWindowsButMainAndCurrent()
"  for win in getwininfo()
"    if get(win.variables, 'ventana_window_name', '') !=# 'main' && win.winnr !=# winnr()
"      execute 'close ' .. win.winnr
"    endif
"  endfor
"endfunction
"
"function! MoveToAuxiliary()
"  call CloseAllWindowsButMainAndCurrent()
"  wincmd L
"  let w:ventana_window_name = 'auxiliary'
"endfunction
"
"function! DetectAndMoveToAuxiliary()
"  for file_type in ['help', 'git', 'fugitive']
"    if &filetype == file_type
"      call MoveToAuxiliary()
"      return
"    endif
"  endfor
"endfunction
"
"autocmd FileType help,git,gitcommit,fugitive call MoveToAuxiliary()
"
"nnoremap <C-t> :call FocusTerminal()<CR>
"nnoremap <C-m> :call FocusMainWindow()<CR>
"tnoremap <c-t> <C-\><C-n>:call FocusTerminal()<CR>
"tnoremap <c-m> <C-\><C-n>:call FocusMainWindow()<CR>


"===========================================================================
" old window management stuff
"===========================================================================

"" make terminal easier to use
"function! FocusTerminal()
"  let windowCount = winnr('$')
"  if windowCount < 2
"    wincmd n
"  elseif windowCount > 2
"    return
"  endif
"  wincmd l
"  for buf in getbufinfo()
"    if getbufvar(buf.bufnr, 'semantic_buffers_type', 'notset') == 'terminal'
"      call execute(':buffer ' . buf.bufnr)
"      normal A
"      return
"    endif
"  endfor
"  terminal
"  setlocal nonumber
"  let b:semantic_buffers_type = 'terminal'
"  normal A
"endfunction
"nnoremap <C-t> :call FocusTerminal()<CR>
"
"" open new windows in auxiliary window on the right
"function! OpenWindowOnRight()
"  let currentBuffer = bufnr("%")
"  let windowCount = winnr('$')
"  if windowCount == 2
"    wincmd L
"  elseif windowCount == 3
"    close
"    wincmd l
"    call execute(':buffer' . currentBuffer)
"  endif
"endfunction
"autocmd WinNew * call OpenWindowOnRight()

