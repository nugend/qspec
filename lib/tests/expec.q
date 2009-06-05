\d .tst
runExpec:{[expec];
 expec[`result]:();
 ((` sv `.q,) each uiRuntimeNames,key asserts) .tst.mock' uiRuntimeCode,value asserts;
 expec,: @[{x[];()};expec`before;expecError[expec;"before"]];
 / Only run the expectation code when the setup works
 if[not count expec[`result];expec,: @[callExpec;expec;expecError[expec;string expec[`type]]]]; 
 expec,: @[{x[];()};expec`after;expecError[expec;"after"]];
 .tst.restore[];
 / Clear any state for assertions
 .tst.assertState:.tst.defaultAssertState;
 expec
 }

expecError:{[expec;errorType;errorText];
 expec[`result]: `$errorType,"Error";
 expec[`errorText],:errorText;
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
