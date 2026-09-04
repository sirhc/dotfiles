function! vimwiki_diary#Template()
  python3 << EOF
  import vim
  from datetime import datetime, timedelta

  sun = datetime.fromisoformat(vim.eval("expand('%:t:r')")) - timedelta(days=1)  # .../diary/2025-11-10.wiki -> 2025-11-09
  mon = sun + timedelta(days=1)  # 2025-11-10
  tue = sun + timedelta(days=2)  # 2025-11-11
  wed = sun + timedelta(days=3)  # 2025-11-12
  thu = sun + timedelta(days=4)  # 2025-11-13
  fri = sun + timedelta(days=5)  # 2025-11-14
  sat = sun + timedelta(days=6)  # 2025-11-15

  def fmt(date):
    return date.strftime("%Y-%m-%d")

  vim.command(f"let l:week = '= Week of { mon.strftime("%B %e, %Y") } ='")
  vim.command(f"let l:mon  = '== Monday | due:{ fmt(mon) } or +OVERDUE or (status:completed end:{ fmt(mon) }) -VISIBLE | due:{ fmt(mon) } !{ fmt(tue) } =='")
  vim.command(f"let l:tue  = '== Tuesday | due:{ fmt(tue) } or +OVERDUE or (status:completed end:{ fmt(tue) }) -VISIBLE | due:{ fmt(tue) } !{ fmt(wed) } =='")
  vim.command(f"let l:wed  = '== Wednesday | due:{ fmt(wed) } or +OVERDUE or (status:completed end:{ fmt(wed) }) -VISIBLE | due:{ fmt(wed) } !{ fmt(thu) } =='")
  vim.command(f"let l:thu  = '== Thursday | due:{ fmt(thu) } or +OVERDUE or (status:completed end:{ fmt(thu) }) -VISIBLE | due:{ fmt(thu) } !{ fmt(fri) } =='")
  vim.command(f"let l:fri  = '== Friday | due:{ fmt(fri) } or +OVERDUE or (status:completed end:{ fmt(fri) }) -VISIBLE | due:{ fmt(fri) } !{ fmt(sat) } =='")
  vim.command(f"let l:task = '== Tasks | (status:pending (due: or due.after:{ fmt(fri) })) or (end.after:{ fmt(sun) }) -VISIBLE !{ fmt(sat) } =='")
EOF

  call append(0, [ l:week, '', l:mon, '', l:tue, '', l:wed, '', l:thu, '', l:fri, '', l:task ])
endfunction
