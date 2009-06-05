.tst.desc["Loading Text Fixtures"]{
 before{
  fix: ` sv (` vs .tst.tstPath)[0],`fixtures`all_types.csv;
  `typeLine mock ssr[(read0 fix) 0;",";""];
  };
 should["load text based fixtures with different path separators"]{
  fixture[`fixtureCommas];
  fixture[`fixturePipes];
  fixture[`fixtureCarets];
  fixtureCommas mustmatch fixturePipes;
  fixtureCommas mustmatch fixtureCarets;
  };
 should["determine the types of the fixture's columns from the type-line"]{
  fixtureAs[`all_types;`allTypes];
  nullTypes: typeLine$" ";
  nullTypes mustmatch value first allTypes;
  };
 };
