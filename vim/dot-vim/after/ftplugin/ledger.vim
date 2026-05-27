setlocal scrolloff=10
setlocal shiftwidth=4
setlocal tabstop=4

let g:ledger_extra_options = '--strict ordereddates payees uniqueleafnames'

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
  pattern = re.compile(r'^(.*?)(\d[\d\s,.()*/+-]+?)(\s+;.*)?$')
  match = pattern.match(vim.current.buffer[row - 1])

  if not match:
    print(f'Error: Failed to parse line: "{vim.current.buffer[row - 1]}".')
    return

  try:
    vim.current.buffer[row - 1] = f'{match.group(1)}{round(float(eval(match.group(2).replace(',', ''))), 2):.2f}{match.group(3) if match.group(3) else ''}'
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

  pattern = re.compile(r'^(.*?)(-?\d+\.\d+)(.*)$')  # capture (1) account/spacing/sign, (2) amount, (3) any trailing comment
  split1 = pattern.match(vim.current.buffer[row - 1])
  split2 = pattern.match(vim.current.buffer[row])

  if not split1:
    print(f'Error: Failed to parse line: "{vim.current.buffer[row - 1]}".')
    return

  if not split2:
    print(f'Error: Failed to parse line: "{vim.current.buffer[row]}".')
    return

  vim.current.buffer[row - 1] = f"{split1.group(1)}{round(float(split1.group(2)) + float(split2.group(2)), 2):.2f}{split1.group(3)}"
  del vim.current.buffer[row]  # removed merged split

merge_lines()
EOF
endfunction
EOF
endfunction

nnoremap <silent> <buffer> <Leader>s :call ledger#transaction_state_toggle(line('.'), ' *?!')<CR>
nnoremap <silent> <buffer> <Leader>e :call LedgerEvaluateExpression()<CR>
nnoremap <silent> <buffer> <Leader>m :call LedgerMergeNextLine()<CR>

" inoremap <silent> <buffer> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
