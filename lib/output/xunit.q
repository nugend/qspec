.utl.require .tst.PKGNAME,"/output/xml.q"
\d .tst

expecTypes:`test`fuzz`perf!("should";"it holds that";"performs")

output:()!()
output[`top]:{[specs]
  xml.node["test-suite";()!()] raze output.spec each specs
  }
output[`spec]:{[spec];
  e:spec`expectations;
  attrs:`name`reports`skips`tests`errors`failures!(spec`title;1;0;sum e`assertsRun;sum e[`result] like "*Error";sum e[`result]=`testFail);
  attrs,:(`$("test-cases";"errors-detail";"failures-detail"))!(count e;sum e[`result] like "*Error";sum count each e`failures);
  xml.node["test-suite";attrs;-1 _ ` sv output[`expectation] each e]
  }
 
output[`expectation]:{[e];
  label: expecTypes[e`type]," ",name:e[`desc];
  sysout:output[e`type][e];
  atr:`name`label`errors`failures`skip`tests!(name;label;e[`result] like "*Error";count e`failures;0;e`assertsRun);
  xml.node["test-case";atr] $[(e[`result] like "*Error") or count e`failures;
    xml.node["sysout";()!();xml.bodySub sysout];
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

output[`error]:{[e];
 o:$[count e[`errorText];"Error: ",(string e[`result]), " '", e[`errorText],"\n";""];
 if[not output[`anyFailures] e;o,:output[`assertsRun] e];
 o
 }

output[`test]:{[t];
 o:"";
 o,:output.error[t];
 if[output[`anyFailures] t;
  o,:raze "Failure: ",/:t[`failures],\:"\n";
  o,:output[`assertsRun] t;
  ];
 o,:output.code[t];
 o,"\n"
 }

output[`fuzzLimit]:10;
output[`fuzz]:{[f];
 o:"";
 o,:output.error[f];
 / If the fuzz assertions errors out after tests have been run, but not all failure processing has completed, the output will not pring correctly
 / Consider trying to figure out how to print the fuzz that the test failed on (store last fuzz?)
 if[(o~"") and output[`anyFailures] f;
  o,:raze "Failure: ",/:f[`failures],\: "\n";
  o,:"Maximum accepted failure rate: ", (string f[`maxFailRate]), "\n";
  o,:"Failure rate was ", (string f[`failRate]), " for ", (string f[`runs]), " runs\n";
  o,:"Displaying ", (string displayFuzz:min (.tst.output.fuzzLimit;count f[`fuzzFailureMessages])), " of ", (string count f[`fuzzFailureMessages]), " fuzz failures messages\n";
  o,:raze (raze displayFuzz # f[`fuzzFailureMessages]),\:"\n";
  ];
 o,:output.code[f];
 o,"\n"
 }

output[`perf]:{[p];
 }

output[`always]:1b
output[`interactive]:0b
