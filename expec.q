\d .tst
runExpec:{[expec];
 expec[`result]:();
 expec,: @[{x[];()};expec`before;expecError[expec;"before"]];
 / Only run the expectation code when the setup works
 if[not count expec[`result];expec,: @[callExpec;expec;expecError[expec;string expec[`type]]]]; 
 expec,: @[{x[];()};expec`after;expecError[expec;"after"]];
 .tst.restore[];
 / Clear any failure strings made by assertions
 .tst.failures:();
 expec
 }

expecError:{[expec;errorType;errorText];
 expec[`result],: errorType,"Error";
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
 expec[`failures]:.tst.failures;
 expec[`result]: $[count expec`failures;`testFail;`pass];
 expec
 }
