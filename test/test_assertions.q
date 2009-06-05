.tst.desc["Assertions"]{
 should["increment the assertions run counter by one"]{
  assertsRun: .tst.assertState.assertsRun;
  1 musteq 1;
  .tst.assertState.assertsRun musteq 1 + assertsRun;
  };
 should["attach failure messages to the failures lists"]{
  oldFailures: .tst.assertState.failures; / Don't want intentional failures made in the name of testing to cause a test failure
  must[0b;"failure1"];
  must[0b;"faiure2"];
  must[1b;"notfailure"];
  newFailures: .tst.assertState.failures;
  .tst.assertState.failures:oldFailures;
  count[newFailures] musteq 2;
  };
 };
