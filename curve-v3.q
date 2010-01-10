curve:{[syms;start;end];
  kt:([sym:syms];count[syms]#start;end);
  v:select vol: sum size by sym, date, time.minute from trade where date within `date$kt[([]sym)]`start`end, sym in syms, time within `time$kt[([]sym)]`start`end;
  tv: exec sum vol by sym from v;
  numDates:exec count distinct date from v;
  `sym`minute xasc select avgBucket: sum[vol]%numDates, pctDaily:sum[vol]%tv[first sym] by sym,minute from v 
  }
