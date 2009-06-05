.tst.desc["Loading Directory Fixtures"]{
 before{
  `notAFixture mock 1 _ string ` sv (` vs .tst.tstPath)[0],`fixtures`not_a_fixture;
  };
 should["clear any loaded partition"]{
  system "l ",notAFixture; 
  `mytable mustin tables `;
  fixture `a_fixture;
  `mytable mustnin tables `;
  };
 should["only load one directory fixture at a time"]{
  fixture `a_fixture;
  `sometable mustin tables `;
  fixture `other_fixture;
  `sometable mustnin tables `;
  `othertable mustin tables `;
  };
 should["allow you to restore to the previously loaded partition"]{
  system "l ", notAFixture;
  fixture `a_fixture;
  .tst.restoreDir[];
  `mytable mustin tables `;
  };
 };
