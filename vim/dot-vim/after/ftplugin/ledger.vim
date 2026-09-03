setlocal nowrap
setlocal scrolloff=10
setlocal shiftwidth=4
setlocal tabstop=4

let g:ledger_bin = 'hledger'
let g:ledger_is_hledger = v:true
let g:ledger_extra_options = '--strict ordereddates payees uniqueleafnames'
let g:ledger_fuzzy_account_completion = 1
let g:ledger_detailed_first = 1
let g:ledger_accounts_spell = 1
let g:ledger_default_commodity = '$'
let g:ledger_commodity_before = 1
let g:ledger_commodity_sep = ''
let g:ledger_commodity_spell = 1
let g:ledger_fold_blanks = 1
let g:ledger_date_format = '%Y-%m-%d'

" ==============================================================================
" Function:    LedgerYankTransaction
" Description: Overrides the standard 'Y' (yank line) behavior inside ledger
"              files to yank the entire multi-line transaction block at the
"              cursor.
"
" Usage:       Place the cursor anywhere inside a transaction (on the date line,
"              an expense split, or a comment) and press 'Y'.
"
" Behavior:    - Locates the transaction header by looking backward for an
"                unindented line starting with a digit (i.e., a date).
"              - Identifies the end of the transaction by looking forward to
"                the next header block.
"              - Trims trailing empty buffer lines.
" ==============================================================================

function! LedgerYankTransaction()
	let l:start = search('^\d', 'bcnW')
  if l:start == 0
    echo 'No transaction.'
    return
  endif

  let l:end = search('^\d', 'nW')
  if l:end == 0
    " Hit the end of the file without finding another transaction header.
    let l:end = line('$')
  else
    let l:end = l:end - 1
  endif

  " Trim trailing blank lines within the block boundary.
  while getline(l:end) =~ '^\s*$'
    let l:end -= 1
  endwhile

  execute l:start . ',' . l:end . 'yank'
endfunction

" ==============================================================================
" Function:    LedgerEvaluateExpression
" Description: Evaluates an inline math expression on the current line,
"              replacing it with the calculated total.
"
" Usage:       1. Set the split amount to an algebraic expression. For example:
"                 * expenses:foo  46.14 * 1.0775  ; apply a 7.75% sales tax
"                 * expenses:bar  1.14 + (15.50 / 2)
"              2. Place the cursor anywhere on that line.
"              3. Trigger the macro (default: <Leader>e).
"
" Behavior:    - Strips thousands-separator commas during the calculation phase.
"              - Outputs the result rounded to two decimal places (e.g., 1077.50).
"              - Preserves account names, spacing, and comments.
"              - Reports errors if the line fails to parse or if the
"                expression evaluation encounters an error (like division by
"                zero).
" ==============================================================================

function! LedgerEvaluateExpression()
python3 << EOF
import vim
import re

def evaluate_expression():
  row = vim.current.window.cursor[0]  # note, cursor position is 1-indexed
  pattern = re.compile(r'^(.*?)(-?\d[\d\s,.()*/+-]+?)(\s+;.*)?$')
  match = pattern.match(vim.current.buffer[row - 1])

  if not match:
    print(f'Error: Failed to parse line: "{vim.current.buffer[row - 1]}".')
    return

  try:
    vim.current.buffer[row - 1] = f'{match.group(1)}{round(float(eval(match.group(2).replace(',', ''))), 2):,.2f}{match.group(3) if match.group(3) else ''}'
  except Exception as e:
    print(f'Error: "{match.group(2)}": {e}')

evaluate_expression()
EOF
endfunction

" ==============================================================================
" Function:    LedgerMergeNextLine
" Description: Merges the amount from the line directly below into the current
"              line, summing their values and deleting the second line.
"
" Usage:       1. Place the cursor on the primary split (e.g., an expense).
"              2. Trigger the macro (default: <Leader>m).
"              3. The split below will have its amount added to the current
"                 split, and the split below will be deleted.
"
" Behavior:    - Preserves the spacing, layout, and comments of the split.
"              - Discards the account and comments of the merged split.
"              - Aborts safely without changes if:
"                * There is no split below the cursor.
"                * Either split has an invalid amount.
" ==============================================================================

function! LedgerMergeNextLine()
python3 << EOF
import vim
import re

def merge_lines():
  row = vim.current.window.cursor[0]  # note, cursor position is 1-indexed

  if row == len(vim.current.buffer):
    print('Error: No line below to merge.')
    return

  if not re.match(r'^\s{2,}\w', vim.current.buffer[row]):
    print('Error: No split below to merge.')
    return

  pattern = re.compile(r'^(.*?)(-?\d[\d,]*\.\d+)(.*)$')  # capture (1) account/spacing/sign, (2) amount, (3) any trailing comment
  split1 = pattern.match(vim.current.buffer[row - 1])
  split2 = pattern.match(vim.current.buffer[row])

  if not split1:
    print(f'Error: Failed to parse line: "{vim.current.buffer[row - 1]}".')
    return

  if not split2:
    print(f'Error: Failed to parse line: "{vim.current.buffer[row]}".')
    return

  vim.current.buffer[row - 1] = f"{split1.group(1)}{round(float(split1.group(2).replace(',', '')) + float(split2.group(2).replace(',', '')), 2):,.2f}{split1.group(3)}"
  del vim.current.buffer[row]  # removed merged split

merge_lines()
EOF
endfunction

" ==============================================================================
" Function:    LedgerDistributeProportional
" Description: Distributes a target value (e.g., sales tax or a discount)
"              proportionally across a set of splits based on their relative
"              weights.
"
" Usage:       1. Visually select a range of lines in a ledger transaction.
"              2. The LAST line of the selection is treated as the target amount.
"              3. The preceding lines are treated as the base splits.
"              4. Trigger the macro (default: <Leader>d).
"
" Behavior:    - Distributes the target amount proportionally.
"              - Automatically handles rounding remainders by assigning the
"                leftover pennies to the split with the largest absolute value.
"              - Deletes the original target split upon successful distribution.
"              - Aborts safely with an error message if:
"                * Fewer than two lines are selected.
"                * Any selected line fails to parse.
"                * The sum of the base splits equals zero.
" ==============================================================================

function! LedgerDistributeProportional() range
python3 << EOF
import vim
import re

def run_distribution():
  start_line = int(vim.eval("a:firstline"))
  end_line = int(vim.eval("a:lastline"))

  if end_line - start_line < 1:
    print("Error: You must select at least two lines.")
    return

  pattern = re.compile(r"^(.*?)(\-?\d[\d,]*(?:\.\d+)?)(.*)$")
  splits = []

  for i in range(start_line - 1, end_line):
    m = pattern.match(vim.current.buffer[i])
    if not m:
      print(f'Error: Failed to parse line: "{vim.current.buffer[i]}".')
      return

    prefix, amount, suffix = m.groups()
    splits.append({'prefix': prefix, 'amount': float(amount.replace(',', '')), 'suffix': suffix})

  target = splits[-1]   # the last split, to be distributed
  splits = splits[:-1]  # the splits to receive the distribution

  total = sum(split['amount'] for split in splits)
  if total == 0:
    # This can happen if I do something dumb like,
    #   expenses:foo   $100.00
    #   expenses:bar  $-100.00
    #   expenses:baz    $50.00
    print('Error: Sum of splits cannot be zero.')
    return

  allocated_total = 0
  for split in splits:
    split['addition'] = round(target['amount'] * (split['amount'] / total), 2)
    allocated_total += split['addition']

  remainder = round(target['amount'] - allocated_total, 2)
  if remainder != 0:
    largest_split = max(splits, key=lambda x: abs(x['amount']))
    largest_split['addition'] = round(largest_split['addition'] + remainder, 2)

  for i, split in enumerate(splits):
    vim.current.buffer[start_line - 1 + i] = f"{split['prefix']}{(split['amount'] + split['addition']):,.2f}{split['suffix']}"

  # Remove the target line, which is now fully distributed.
  del vim.current.buffer[end_line - 1]

run_distribution()
EOF
endfunction

function! LedgerLocListByAccount(account) abort
  let l:json = system(g:ledger_bin .. ' print --output-format=json --file=- ' .. shellescape('acct:^' . a:account . '$'), getline(1, '$'))
  let l:txns = json_decode(l:json)

  if empty(l:txns)
    echohl WarningMsg | echo 'No transactions found for account ' .. a:account .. '.' | echohl None
    return
  endif

  let l:loclist = []
  let l:bufnr = bufnr('%')

  for l:txn in l:txns
    let l:tstatus = ' '
    if l:txn.tstatus == 'Cleared'
      let l:tstatus = '*'
    elseif l:txn.tstatus == 'Pending'
      let l:tstatus = '!'
    endif

    let l:amount = '$0.00'
    for l:posting in l:txn.tpostings
      if l:posting.paccount ==# a:account
        let l:amount = printf('%s%.2f', l:posting.pamount[0].acommodity, l:posting.pamount[0].aquantity.floatingPoint)
        break
      endif
    endfor

    call add(l:loclist, {
      \ 'bufnr': l:bufnr,
      \ 'lnum':  l:txn.tsourcepos[0].sourceLine,
      \ 'text':  printf('%s %s %10s %s', l:txn.tdate, l:tstatus, l:amount, l:txn.tdescription),
      \ })
  endfor

  call setloclist(0, reverse(l:loclist), 'r')
  call setloclist(0, [], 'a', {'title': a:account})
  lopen
endfunction

function! LedgerAccountComplete(ArgLead, CmdLine, CursorPos) abort
  let l:accounts = systemlist(g:ledger_bin .. ' accounts --file=-', getline(1, '$'))
  if v:shell_error != 0 || empty(l:accounts)
    return []
  endif

  " Filter accounts based on what's been typed so far (case-insensitive substring/prefix match).
  return filter(l:accounts, 'v:val =~? "^" . escape(a:ArgLead, "\\")')
endfunction

function! LedgerFzfAccounts() abort
  call fzf#run(fzf#wrap('ledger-accounts', {
    \ 'source':  systemlist(g:ledger_bin .. ' --file=- accounts', getline(1, '$')),
    \ 'sink':    function('LedgerLocListByAccount'),
    \ 'options': ['--prompt', 'Account> ', '+m']
    \ }))
endfunction

command! -buffer -nargs=1 -complete=customlist,LedgerAccountComplete LedgerLoc call LedgerLocListByAccount(<q-args>)
nnoremap <buffer> <leader>ff :call LedgerFzfAccounts()<CR>

nnoremap <silent> <buffer> Y :call LedgerYankTransaction()<CR>
nmap <silent> <buffer> + <C-a>
nmap <silent> <buffer> - <C-x>

inoremap <silent> <buffer> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
vnoremap <silent> <buffer> <Tab> :LedgerAlign<CR>

nnoremap <silent> <buffer> <C-s> :call ledger#transaction_state_toggle(line('.'), ' *?!')<CR>

vnoremap <silent> <buffer> <Leader>s :sort<CR>
nnoremap <silent> <buffer> <Leader>e :call LedgerEvaluateExpression()<CR>
nnoremap <silent> <buffer> <Leader>m :call LedgerMergeNextLine()<CR>
vnoremap <silent> <buffer> <Leader>d :call LedgerDistributeProportional()<CR>

inoremap <silent> <buffer> <C-d> <C-r>=strftime('%F')<CR>
