.tst.desc["Volume curves"]{
  before{
    fixture `trade;
    };
  should["have percentage values that add to 1"]{
    c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
    (value exec first sum pctDaily by sym from c) musteq 1f;
    c:curve[`IBM`MSFT;2009.11.01T12:00;2009.11.15T15:00];
    (value exec first sum pctDaily by sym from c) musteq 1f;
    };
  alt{
    before{
      fixture `trade;
      `adv mock exec avg vol by sym from select vol:sum size by sym, date from trade where date within 2009.11.01 2009.11.30,time within 09:30 16:00;
      };
    should["have the sum of average bucket volumes be equal to the average daily volume"]{
      c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
      (exec first sum avgBucket by sym from c)[`MSFT`IBM] musteq adv[`MSFT`IBM];
      };
    should["have the percentage of daily volume match the average bucket column divided by ADV"]{
      c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
      (exec avgBucket%adv[first sym] by sym from c)[key pd] mustmatch pd[key pd:exec pctDaily by sym from c;];
      };
    };
  should["be able to retrieve curves across different time periods"]{
    mustnotthrow[();(`curve;`IBM`MSFT;2009.11.01T09:30 2009.11.01T09:35;2009.11.30T16:00 2009.11.30T15:55)];
    };
  };
