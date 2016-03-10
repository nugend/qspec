.tst.desc["Running an Expectation"]{
 before{
  `.tst.contextHelper mock {[x;y] system "d ", string x} system "d"; / Need to change back to the proper execution context after every call that refers to a mocked variable in the current context
  `myRestore mock .tst.restore; / Mocking restore so the UI doesn't get clobbered
  `.tst.restore mock {};
  `.tst.expecList mock .tst.expecList;
  `.tst.currentBefore mock .tst.currentBefore;
  `.tst.currentAfter mock .tst.currentAfter;
  `.tst.callbacks.expecRan mock {[x;y]}; / Mock this out so expectations run TO test running expectations don't count towards test expectations ran
  `getExpec mock {last .tst.fillExpecBA .tst.expecList};
  };
 after{
  myRestore[];
  };
 should["call the main expectation function"]{
  `ran mock 0b;
  should["run this"]{`ran mock 1b};
  e:getExpec[];
  .tst.runExpec[();e];
  .tst.contextHelper[];
  must[ran;"Expected the expectation to have run."];
  };
 should["call the before function before calling the main expectation function"]{
  `beforeRan`ran mock' 0b;
  should["run this"]{`ran mock 1b and beforeRan};
  before {`beforeRan mock 1b};
  e:getExpec[];
  .tst.runExpec[();e];
  .tst.contextHelper[];
  must[beforeRan;"Expected the before expectation to run"];
  must[ran;"Expected the main expectation to run after the before function"];
  };
 should["call the after function after calling the main expectation function"]{
  `afterRan`ran mock' 0b;
  should["run this"]{`ran mock 1b};
  after {`afterRan mock 1b and ran};
  e:getExpec[];
  .tst.runExpec[();e];
  .tst.contextHelper[];
  must[ran;"Expected the main expectation to run"];
  must[afterRan;"Expected the after function to run after the main expectation"];
  };
 should["make assertions available to be used within the expectation"]{
  `.q.must mock {[x;y];'"fail"};
  should["run this"]{`noError mock @[{must[1b;"silent pass"];1b};(::);0b]};
  e:getExpec[];
  .tst.runExpec[();e];
  .tst.contextHelper[];
  must[noError;"Expected the assertion method to not throw an error"];
  };
 should["execute the expectation in the correct context"]{
  should["change context"]{`..context mock system "d";};
  e:getExpec[];
  `.tst.context mock `.foo;
  .tst.runExpec[();e];
  `.[`context] mustmatch `.foo;
  };
 should["restore mocked values after all expectation functions have executed"]{
  `ran mock 0b;
  `.tst.restore mock {`ran mock 1b};
  should["run this"]{};
  e:getExpec[];
  .tst.runExpec[();e];
  .tst.contextHelper[];
  must[ran;"Expected the mocking restore function to have been called"];
  };
 should["prevent errors from escaping when running the expectation"]{
  should["run this"]{'foo};
  e:getExpec[];
  .tst.runExpec[();e];
  mustnotthrow[();{[x;y] .tst.runExpec[x]}[e]];
  };
 should["call the expecRan callback with the results of running the expectation and current specification"]{
  `..callbackCalled mock 0b;                                / The context will be in .tst when the callback is executed
  `.tst.callbacks.expecRan mock {[x;y]`..callbackCalled set 1b};
  should["run this"]{};
  e:getExpec[];
  .tst.runExpec[();e];
  .tst.contextHelper[];
   must[callbackCalled;"Expected the descLoaded callback to have been called"];
  };
 should["restage an expectation if the test run is to immediately halt"]{
  `beforeCounter mock 0;;
  `restoreCounter mock 0;
  `.tst.restore mock {restoreCounter+:1};
  `.tst.halt mock 1b;
  before{beforeCounter+:1};
  should["restage"]{'"foo"};
  e:getExpec[];
  .tst.runExpec[();e];
  beforeCounter musteq 2;
  restoreCounter musteq 1;
  };
 };
