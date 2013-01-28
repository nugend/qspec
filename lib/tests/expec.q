\d .tst
runExpec:{[spec;expec];
 time:.z.n;
 startExpec:expec;
 expec:setupExpec[spec;expec];
 beforeBad:`before;
 expec,: @[{x[];()};expec`before;expecError[expec;"before"]];
 beforeBad:`test;
 / Only run the expectation code when the setup works
 if[not count expec[`result];expec,: @[callExpec;expec;expecError[expec;string expec[`type]]]];
 beforeBad:`after;
 expec,: @[{x[];()};expec`after;expecError[expec;"after"]];
 expec:teardownExpec[spec;expec];
 if[.tst.halt;
  stageBadExpec[spec;startExpec;beforeBad];
  ];
 expec[`time]:.z.n - time;
 expec
 }

stageBadExpec:{[spec;expec;beforeBad]
 expec:setupExpec[spec;expec];
 if[beforeBad ~ `before;:(::)];
 expec,: @[{x[];()};expec`before;expecError[expec;"before"]];
 if[beforeBad ~ `test;:(::)];
 @[callExpec;expec;expecError[expec;string expec[`type]]];
 }

setupExpec:{[spec;expec];
 expec[`result]:();
 ((` sv `.q,) each uiRuntimeNames,key asserts) .tst.mock' uiRuntimeCode,value asserts;
 system "d ", string .tst.context;
 expec
 }

teardownExpec:{[spec;expec];
 system "d .tst";
 .tst.restore[];
 / Clear any state for assertions
 .tst.assertState:.tst.defaultAssertState;
 .tst.callbacks.expecRan[spec;expec];
 expec
 }

expecError:{[expec;errorType;errorText];
 expec[`result]: `$errorType,"Error";
 expec[`errorText],:errorText;
 expec[`failures]:.tst.assertState.failures;
 expec[`assertsRun]:.tst.assertState.assertsRun;
 expec
 }

callExpec:{[expec];
 $[expec[`type] in  key runners;
 runners[expec`type] expec;
 'badExpecType]
 }

runners:()!()
runners[`perf]:{[expec];}
runners[`test]:{[expec];
 expec[`code][];
 / We use just a dab of state to communicate with the assertions
 expec[`failures]:.tst.assertState.failures;
 expec[`assertsRun]:.tst.assertState.assertsRun;
 expec[`result]: $[count expec`failures;`testFail;`pass];
 expec
 }
