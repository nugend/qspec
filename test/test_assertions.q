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
  testedFailures: .tst.assertState.failures;
  .tst.assertState.failures:oldFailures;
  count[testedFailures] musteq 2;
  };
 };
.tst.desc["Error Assertions"]{
 before{
  `oldFailures mock .tst.assertState.failures; / Don't want intentional failures made in the name of testing to cause a test failure
  };
 should["catch errors"]{
  mustnotthrow[()]{
   mustthrow[();{'"foo"}];
   mustnotthrow[();{'"foo"}];
   .tst.assertState.failures:oldFailures;
   };
  };
 should["report only thrown exceptions that were not supposed to have been thrown"]{
  mustnotthrow["foo";{'"foo"}];
  mustnotthrow["foo";{'"bar"}];
  testedFailures: .tst.assertState.failures;
  .tst.assertState.failures:oldFailures;
  first[testedFailures] mustlike "*to not throw the error 'foo'*";
  count[testedFailures] musteq 1;
  };
 should["report only unthrown exceptions that were supposed to have been thrown"]{
  mustthrow["foo";{'"bar"}];
  mustthrow["foo";{'"foo"}];
  mustthrow[("foo";"baz");{'"bar"}];
  mustthrow["foo";{""}];
  testedFailures: .tst.assertState.failures;
  .tst.assertState.failures:oldFailures;
  testedFailures[0] mustlike "*the error 'foo'. Error thrown: 'bar'*";
  testedFailures[1] mustlike "*one of the errors 'foo','baz'. Error thrown: 'bar'*";
  testedFailures[2] mustlike "*the error 'foo'. No error thrown*";
  count[testedFailures] musteq 3;
  };
 };
