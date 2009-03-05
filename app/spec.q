.u.require "qutil/opts.q"
.u.require "qspec"
.tst.loadOutputModule["text"]

.u.addOpt["desc,describe";1b;`describeOnly]
.u.addOpt["perf,performance";1b;`runPerformance]
.u.addOpt["exclude";(),"*";`excludeSpecs]
.u.addOpt["only";(),"*";`runSpecs]

if[describeOnly;.tst.output.mode:`describe];

specs:()

.tst.callbacks.loadDesc:{[specObj];
 specs,:enlist specObj;
 }

system each "l ",/:.u.args;
 
output: raze .tst.output.spec each specs

-1 output;

