.tst.desc["Running an Expectation"]{
 before{
  `.tst.contextHelper mock {[x;y] system "d ", string x} system "d"; / Need to change back to the proper execution context after every call that refers to a mocked variable in the current context
  `myRestore mock .tst.restore; / Mocking restore so the UI doesn't get clobbered
  `.tst.restore mock {};
  `.tst.expecList mock .tst.expecList;
  `.tst.currentBefore mock .tst.currentBefore;
  `.tst.currentAfter mock .tst.currentAfter;
  };
 after{
  myRestore[];
  };
 should["call the main expectation function"]{
  `ran mock 0b;
  should["run this"]{`ran mock 1b};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  must[ran;"Expected the expectation to have run."];
  };
 should["call the before function before calling the main expectation function"]{
  `ran mock 0b;
  before {`ran mock 1b};
  should["run this"]{`ran mock 1b and ran};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  must[ran;"Expected the main expectation to run after the before function"];
  };
 should["call the after function after calling the main expectation function"]{
  `ran mock 0b;
  should["run this"]{`ran mock 1b};
  after {`ran mock 1b and ran};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  must[ran;"Expected the after function to run after the main expectation"];
  };
 should["make assertions available to be used within the expectation"]{
  `.q.must mock {[x;y];'"fail"};
  should["run this"]{`noError mock @[{must[1b;"silent pass"];1b};(::);0b]};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  must[noError;"Expected the assertion method to not throw an error"];
  };
 should["execute the expectation in the correct context"]{
  should["change context"]{`..context mock system "d";};
  e: last .tst.expecList;
  `.tst.context mock `.foo;
  .tst.runExpec[e];
  `.[`context] mustmatch `.foo;
  };
 should["restore mocked values after all expectation functions have executed"]{
  `ran mock 0b;
  `.tst.restore mock {`ran mock 1b};
  should["run this"]{};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  must[ran;"Expected the mocking restore function to have been called"];
  };
 should["prevent errors from escaping when running the expectation"]{
  should["run this"]{'foo};
  e: last .tst.expecList;
  .tst.runExpec e;
  mustnotthrow[();{[x;y] .tst.runExpec[x]}[e]];
  };
 };
