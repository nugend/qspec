\d .tst

typeNames:`test`fuzz`perf!("should";"it holds that";"performs")

output:()!()
output[`spec]:{[spec];
 o: spec[`title],"::\n";
 o,: raze output[`expectation] each spec[`expectations] $[.tst.output.mode ~ `describe;
  (::);
  where spec[`expectations;;`result] <> `pass];
 o,"\n"
 }
 
output[`expectation]:{[e];
 o: "- ",typeNames[e`type]," ",e[`desc],$[.tst.output.mode ~ `describe;"";":"],"\n";
 if[not .tst.output.mode ~ `describe;
  o,:output[e`type][e];
 ];
 o
 }
 
output[`test]:{[t];
 o:"";
 if[count t[`errorText];
  o,: "Error: ",(string t[`result]), " '", t[`errorText],"\n"
  ];
 if[(`failures in key t) and count t[`failures];
  o,:raze "Failure: ",/:t[`failures],\:"\n";
  o,:(string t[`assertsRun]), $[1 = t[`assertsRun];" assertion was";" assertions were"]," run.\n";
  ];
 if[not "{}" ~ last value t[`before];o,:"Before code: \n", (last value t[`before]),"\n"];
 o,:"Test code: \n",(last value t[`code]),"\n";
 if[not "{}" ~ last value t[`after];o,:"After code: \n", (last value t[`after]),"\n"];
 o,"\n"
 }

output[`fuzz]:{[f];
 }

output[`perf]:{[p];
 }
