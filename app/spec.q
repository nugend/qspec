\d .tst
.utl.require "qutil/opts.q"
.utl.require "qspec"
.tst.loadOutputModule["text"]
.tst.app.excludeSpecs:();
.tst.app.runSpecs:();
.tst.output.mode: `run

.utl.addOpt["desc,describe";1b;`.tst.app.describeOnly]
.utl.addOpt["perf,performance";1b;`.tst.app.runPerformance]
.utl.addOpt["exclude";(),"*";`.tst.app.excludeSpecs]
.utl.addOpt["only";(),"*";`.tst.app.runSpecs]
.utl.addOpt["pass";1b;`.tst.app.passOnly]
.utl.addOpt["noquit";0b;`.tst.app.exit]
.utl.addOpt["perf-display-limt,pdf";"I";`.tst.output.fuzzLimit]

if[not count .utl.args;1 "Must supply files to load!";exit 1]

if[app.describeOnly;.tst.output.mode:`describe];

app.specs:()

.tst.callbacks.loadDesc:{[specObj];
 .tst.app.specs,:enlist specObj;
 }

\d .
(.tst.loadTests hsym `$) each .utl.args;
\d .tst

if[not app.runPerformance;.tst.app.specs[;`expectations]: {x .[;();_;]/ where x[;`type] = `perf} each app.specs[;`expectations]];
if[0 <> count app.runSpecs;.tst.app.specs: app.specs where (or) over app.specs[;`title] like/: app.runSpecs];
if[0 <> count app.excludeSpecs;.tst.app.specs: app.specs where not (or) over app.specs[;`title] like/: app.excludeSpecs];
 
app.results: $[not app.describeOnly;.tst.runSpec each app.specs;app.specs]

if[not app.passOnly; 1 {$["\n" = last x; -1 _ x;x]} raze .tst.output.spec each app.results];

app.returnCode: not all `pass = app.results[;`result]

if[app.exit; exit `int$app.returnCode];
