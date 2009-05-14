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
  .tst.restoreDir[];         / This is a limitation of the fixture system: If a directory is loaded through the normal manner without first restoring (IE: Cleaningup the fixture) the fixture that was loaded will left hanging around.  Moral of the story: Don't load directories in Specification objects that use fixtures
  };
 should["allow you to restore to the previously loaded partition"]{
  system "l ", notAFixture;
  fixture `a_fixture;
  .tst.restoreDir[];
  `mytable mustin tables `;
  };
 should["leave loaded partitions untouched if restore is called twice after loading a directory fixture"]{
  system "l ", notAFixture;
  fixture `a_fixture;
  .tst.restoreDir[];
  .tst.restoreDir[];
  `mytable mustin tables `;
  `othertable mustnin tables `;
  };
 };
