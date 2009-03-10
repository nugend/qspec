\d .tst
.u.require "qutil/opts.q"
.u.require "qspec"
.tst.loadOutputModule["text"]
.tst.app.excludeSpecs:();
.tst.app.runSpecs:();
.tst.output.mode: `run

.u.addOpt["desc,describe";1b;`.tst.app.describeOnly]
.u.addOpt["perf,performance";1b;`.tst.app.runPerformance]
.u.addOpt["exclude";(),"*";`.tst.app.excludeSpecs]
.u.addOpt["only";(),"*";`.tst.app.runSpecs]
.u.addOpt["pass";1b;`.tst.app.passOnly]
.u.addOpt["noquit";0b;`.tst.app.exit]
.u.addOpt["perf-display-limt,pdf";"I";`.tst.output.fuzzLimit]

if[app.describeOnly;.tst.output.mode:`describe];

app.specs:()

.tst.callbacks.loadDesc:{[specObj];
 .tst.app.specs,:enlist specObj;
 }

system each "l ",/:.u.args;

if[not app.runPerformance;.tst.app.specs[;`expectations]: {x .[;();_;]/ where x[;`type] = `perf} each app.specs[;`expectations]];
if[0 <> count app.runSpecs;.tst.app.specs: specs where (or) over specs[;`title] like/: app.runSpecs];
if[0 <> count app.excludeSpecs;.tst.app.specs: specs where not (or) over specs[;`title] like/: app.excludeSpecs];
 
app.result: $[not app.describeOnly;.tst.runSpec each app.specs;app.specs]

if[not app.passOnly; 1 {$["\n" = last x; -1 _ x;x]} raze .tst.output.spec each app.result];

app.returnCode: not all `pass = app.result[;`pass]

if[app.exit; exit `int$app.returnCode];
