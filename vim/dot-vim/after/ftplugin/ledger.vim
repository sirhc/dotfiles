setlocal scrolloff=10
setlocal shiftwidth=4
setlocal tabstop=4

let g:ledger_extra_options = '--strict ordereddates payees uniqueleafnames'

function! LedgerEvaluateExpression()
python3 << EOF
import vim
import re

buf = vim.current.buffer
row, col = vim.current.window.cursor
line = buf[row - 1]

# Match: 1: prefix, 2: math expression, 3: suffix/comment.
# The expression matches digits, commas, dots, operators (+, -, *, /), and parentheses; no white space allowed in the expression.
pattern = re.compile(r"^(.*?)(\d[\d,.()/*+-]+)(.*)$")
match = pattern.match(line)
print(match.group(2))

if match:
  prefix = match.group(1)
  expr = match.group(2).replace(',', '')  # remove commas for evaluation
  suffix = match.group(3)
      
  try:
    # Evaluate the math string and round to 2 decimals.
    result = round(float(eval(expr)), 2)
            
    # Reconstruct the line.
    buf[row - 1] = f"{prefix}{result:,.2f}{suffix}"
  except Exception as e:
    print(e)
EOF
endfunction

function! LedgerMergeNextLine()
python3 << EOF
import vim
import re

# Get the current buffer and cursor position (1-indexed).
buf = vim.current.buffer
row, col = vim.current.window.cursor

# Ensure there is a line below to merge.
if row < len(buf):
  line1 = buf[row - 1]
  line2 = buf[row]

  # Pattern captures: 1: account/spacing, 2: sign/amount, 3: trailing comment.
  pattern = re.compile(r"^(.*?)(\-?\d+\.\d+)(.*)$")
  m1 = pattern.match(line1)
  m2 = pattern.match(line2)

  if m1 and m2:
    # Extract and sum the amounts
    amt1 = float(m1.group(2))
    amt2 = float(m2.group(2))
    total = round(amt1 + amt2, 2)

    # Reconstruct line 1 using its original text and comment.
    # The dollar sign is preserved inside group 1 if it preceded the digits.
    new_line = f"{m1.group(1)}{total:.2f}{m1.group(3)}"

    # Update the buffer: replace line 1, delete line 2.
    buf[row - 1] = new_line
    del buf[row]
EOF
endfunction

nnoremap <silent> <buffer> <Leader>s :call ledger#transaction_state_toggle(line('.'), ' *?!')<CR>
nnoremap <silent> <buffer> <Leader>e :call LedgerEvaluateExpression()<CR>
nnoremap <silent> <buffer> <Leader>m :call LedgerMergeNextLine()<CR>

" inoremap <silent> <buffer> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
