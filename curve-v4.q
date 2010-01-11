curve:{[syms;start;end];
  ot:([]sym:syms;count[syms]#start;end);
  datespans:{(`time$(x;y)) +/: (`date$x) + til 1 + (`date$y) - `date$x};
  rt:(flip `sym`start`end!flip raze syms cross' datespans'[count[syms]#start;end]);
  dates:exec distinct `date$start from rt;
  syms:exec distinct sym by `date$start from rt;
  times:{$[1 = count x;first x;flip x]} each boundaries each exec `time$flip (start;end) by sym, date:`date$start from rt;
  v:select vol: sum size by sym, date, time.minute from trade where date in dates, sym in syms[first date], any each time within' times[([]sym;date)];
  ot,'individualCurve[v]'[ot`sym;ot`start;ot`end]
  }

individualCurve:{[v;symbol;s;e];
  v:select from v where date within `date$(s;e), sym = symbol, minute within `minute$(s;e);
  tv: exec sum vol from v;
  numDates:exec count distinct date from v;
  `range`span`payload!(numDates;(`time$e) - (`time$s);() xkey select avgBucket: sum[vol]%numDates, pctDaily:sum[vol]%tv by minute from v)
  }

boundaries:{
  {
    $[any last[x] within y; 
      (-1 _ x),enlist (min (last[x] 0;y 0);max (last[x] 1;y 1));
      x,enlist y
      ]
    }/[enlist x 0;1 _ x:asc x]
  }
