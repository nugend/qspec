\d .tst

typeNames:`test`fuzz`perf!("should";"it holds that";"performs")

output:()!()
output[`spec]:{[spec];
 o: spec[`title],"::\n";
 o,: raze output[`expectation] each spec[`expectations];
 o,"\n"
 }
 
output[`expectation]:{[e];
 o: "  -",typeNames[e`type]," ",e[`desc],$[.tst.output.mode ~ `describe;"";":"],"\n";
 if[not .tst.output.mode ~ `describe;
  o,:output[e`type][e];
 ];
 o
 }
 
output[`test]:{[t];
 }

output[`fuzz]:{[f];
 }

output[`perf]:{[p];
 }
