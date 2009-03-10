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
 
output[`error]:{[e];
 $[count e[`errorText];"Error: ",(string e[`result]), " '", e[`errorText],"\n";""]
 }
 
output[`test]:{[t];
 o:"";
 o,:output.error[t];
 if[(`failures in key t) and count t[`failures];
  o,:raze "Failure: ",/:t[`failures],\:"\n";
  o,:(string t[`assertsRun]), $[1 = t[`assertsRun];" assertion was";" assertions were"]," run.\n";
  ];
 o,:output.code[t];
 o,"\n"
 }

output[`fuzz]:{[f];
 }

output[`perf]:{[p];
 }
