.utl.require .tst.PKGNAME,"/output/xml.q"
\d .tst

printJUnitTime:{string[`int$`second$x],$["000" ~ ns:3#((9 - count n)#"0"),9#n:string nano:(`long$x) mod 1000000000;"";".",ns]}

expecTypes:`test`fuzz`perf!("should";"it holds that";"performs")

output:()!()
output[`top]:{[specs]
  xml.node["testsuites";()!()] raze output.spec each specs
  }
output[`spec]:{[spec];
  e:spec`expectations;
  attrs:`name`skipped`tests`errors`failures`time!(spec`title;0;count e;sum e[;`result] like "*Error";sum e[;`result]=`testFail;printJUnitTime sum e[;`time]);
  xml.node["testsuite";attrs;-1 _ ` sv output[`expectation] each e]
  }
 
output[`expectation]:{[e];
  label: expecTypes[e`type]," ",name:e[`desc];
  outstr:output[e`type][e];
  atr:`name`time!(label;printJUnitTime e[`time]);
  //if[e[`result] like "*Error";'blah;];
  xml.node["testcase";atr] $[(e[`result] like "*Error") or count e`failures;
    output[e`type][e];
    ""
    ]
  }

output[`code]:{[e];
 o:"";
 if[not "{}" ~ last value e[`before];o,:"Before code: \n", (last value e[`before]),"\n"];
 o,:"Test code: \n",(last value e[`code]),"\n";
 if[not "{}" ~ last value e[`after];o,:"After code: \n", (last value e[`after]),"\n"];
 o
 }

output[`anyFailures]:{[t];(`failures in key t) and count t[`failures]}

output[`assertsRun]:{[t];
 (string t[`assertsRun]), $[1 = t[`assertsRun];" assertion was";" assertions were"]," run.\n"
 }

codeOutput:{[e] (output[`assertsRun] e),output.code e}

output[`error]:{[e];
 o:$[count e[`errorText];
   xml.node["error";`type`message!(e[`errorText];xml.safeString[e`result], " occurred in test execution");xml.cdata codeOutput e];
   ""
   ];
 o
 }

output[`test]:{[t];
 o:"";
 o,:output.error[t];
 if[output[`anyFailures] t;
  o,:raze {xml.node["failure";`type`message!(y;"Assertion failure occured during test");xml.cdata codeOutput x]}[t] each t`failures;
  ];
 o
 }

output[`fuzzLimit]:10;
output[`fuzz]:{[t];
 o:"";
 o,:output.error[t];
 / If the fuzz assertions errors out after tests have been run, but not all failure processing has completed, the output will not pring correctly
 / Consider trying to figure out how to print the fuzz that the test failed on (store last fuzz?)
 if[(o~"") and output[`anyFailures] t;
  o,:raze {[t;f]
   h:"Maximum accepted failure rate: ", (string t[`maxFailRate]), "\n";
   h,:"Failure rate was ", (string t[`failRate]), " for ", (string t[`runs]), " runs\n";
   h,:"Displaying ", (string displayFuzz:min (.tst.output.fuzzLimit;count t[`fuzzFailureMessages])), " of ", (string count t[`fuzzFailureMessages]), " fuzz failures messages\n";
   h,:raze (raze displayFuzz # t[`fuzzFailureMessages]),\:"\n";
   xml.node["failure";`type`message!(f;"Fuzz failure occured during test");xml.cdata h,codeOutput t]
   }[t] each t`failures;
  ];
 o
 }

output[`perf]:{[p];
 }

output[`always]:1b
output[`interactive]:0b
