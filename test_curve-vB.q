.tst.desc["Volume curves"]{
  should["have percentage values that add to 1"]{
    fixture `trade;
    c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
    (value exec first sum pctDaily by sym from c) musteq 1f;
    c:curve[`IBM`MSFT;2009.11.01T12:00;2009.11.15T15:00];
    (value exec first sum pctDaily by sym from c) musteq 1f;
    };
  should["have the sum of average bucket volumes be equal to the average daily volume"]{};
  should["have the percentage of daily volume match the average bucket column divided by ADV"]{};
  };
