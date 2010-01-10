.tst.desc["Volume curves"]{
  before{
    fixture `trade;
    };
  should["have percentage values that add to 1"]{
    c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
    (exec {sum x`pctDaily} each payload from c) musteq 1f;
    c:curve[`IBM`MSFT;2009.11.01T12:00;2009.11.15T15:00];
    (exec {sum x`pctDaily} each payload from c) musteq 1f;
    };
  alt{
    before{
      fixture `trade;
      `adv mock exec avg vol by sym from select vol:sum size by sym, date from trade where date within 2009.11.01 2009.11.30,time within 09:30 16:00;
      };
    should["have the sum of average bucket volumes be equal to the average daily volume"]{
      c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
      (exec sum first[payload]`avgBucket by sym from c)[`MSFT`IBM] musteq adv[`MSFT`IBM];
      };
    should["have the percentage of daily volume match the average bucket column divided by ADV"]{
      c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
      (exec (first[payload]`avgBucket)%adv[first sym] by sym from c)[key pd] mustmatch pd[key pd:exec first[payload]`pctDaily by sym from c;];
      };
    };
  should["be able to retrieve curves across different time periods"]{
    mustnotthrow[();(`curve;`IBM`MSFT;2009.11.01T09:30 2009.11.01T09:35;2009.11.30T16:00 2009.11.30T15:55)];
    };
  should["be able to retrieve curves across different date/time periods"]{
    mustnotthrow[();(`curve;`IBM`MSFT;2009.11.02T09:30 2009.11.01T09:35;2009.11.28T16:00 2009.11.25T15:55)];
    };
  should["be able to retrieve two curves for the same symbol across different date/time periods"]{
    c:curve[`IBM`IBM;2009.11.02T09:30 2009.11.01T09:35;2009.11.28T16:00 2009.11.25T15:55];
    count[c] musteq 2;
    };
  should["return the time span the curve was calculated over"]{
    c:curve[`IBM`MSFT;ts:2009.11.01T09:30;te:2009.11.30T16:00];
    (exec span from c) musteq `time$`datetime$te - ts;
    };
  should["return the date range that the curve was calculated over"]{
    c:curve[`IBM`MSFT;ts:2009.11.01T09:30;te:2009.11.30T16:00];
    (exec range from c) musteq 1 + `int$`datetime$te - ts;
    };
  };

.tst.desc["A Time Boundary calculator"]{
  should["find the minimal non-intersecting boundaries in a list of pairs"]{
    boundaries[(2 4;1 3;5 6)] mustmatch (1 4;5 6);
    boundaries[(3 4t;3 9t;2 6t)] mustmatch enlist 2 9t;
    boundaries[reverse (1 4t;5 9t;12 16t)] mustmatch (1 4t;5 9t;12 16t);
    };
  };
