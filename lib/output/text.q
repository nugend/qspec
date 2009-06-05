\d .tst

typeNames:`test`fuzz`perf!("should";"it holds that";"performs")

output:()!()
output[`spec]:{[spec];
 if[spec[`result] ~ `pass; :""]; / Never print passed specs
 o: spec[`title],"::\n";
 o,: raze output[`expectation] each spec[`expectations] $[.tst.output.mode ~ `describe;
  (::);
  where spec[`expectations;;`result] <> `pass];
 o
 }
 
output[`expectation]:{[e];
 o: "- ",typeNames[e`type]," ",e[`desc],$[.tst.output.mode ~ `describe;"";":"],"\n";
 if[not .tst.output.mode ~ `describe;
  o,:output[e`type][e];
 ];
 o
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
 if[output[`anyFailures] f;
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
