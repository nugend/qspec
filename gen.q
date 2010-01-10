gen:{[syms;prices;nums;start;days];
  raze (enlist each flip `sym`date!flip syms cross start + til days) cross' {[num;price]
    invAbs:{(count[x]?1 -1)*x};
    n:`int$num + first invAbs 1?(1?1f)*num; / Adjust num to generate within 0-100% of base num up or down
    freqs:0f, sums .8 .1 .05 .01 .01 .01 .016 .001 .001 .001;
    sizes:100 200 300 400 500 1000 10000 20000 30000 40000 50000;
    ([]time:asc 09:30t + n?16t - 09:30t;price:price + invAbs n?first 1?.1;size:sizes freqs bin n?1f)
    } .' raze days#'enlist each nums,'prices
  }
