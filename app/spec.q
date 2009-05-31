\d .tst
.utl.require "qutil/lib/opts.q"
.utl.require "qspec/lib"
.tst.loadOutputModule["text"]
.tst.app.excludeSpecs:();
.tst.app.runSpecs:();
.tst.output.mode: `run

.utl.addOpt["desc,describe";1b;(`.tst.app.describeOnly;{if[x;.tst.output.mode:`describe;];x})]
.utl.addOpt["perf,performance";1b;`.tst.app.runPerformance]
.utl.addOpt["exclude";(),"*";`.tst.app.excludeSpecs]
.utl.addOpt["only";(),"*";`.tst.app.runSpecs]
.utl.addOpt["pass";1b;`.tst.app.passOnly]
.utl.addOpt["noquit";0b;`.tst.app.exit]
.utl.addOpt["fuzz-display-limt,fdl";"I";`.tst.output.fuzzLimit]

if[not count .utl.args;-1 "Must supply files to load!";exit 1]

app.specs:()

app.expectationsRan:0
app.expectationsPassed:0
app.expectationsFailed:0
app.expectationsErrored:0

.tst.callbacks.descLoaded:{[specObj];
 .tst.app.specs,:enlist specObj;
 }

if[not[app.describeOnly] and not app.passOnly; / Only want to print this when running to see results
 .tst.callbacks.expecRan:{[e];
  app.expectationsRan+:1;
  r:e[`result];
  if[r ~ `pass; app.expectationsPassed+:1];
  if[r in `fail`fuzzFail; app.expectationsFailed+:1];
  if[r like "*Error"; app.expectationsErrored+:1];
  1 $[r ~ `pass;".";
   r in `fail`fuzzFail;"F";
   r ~ `afterError;"B";
   r ~ `afterError;"A";
   "E"];
  }
 ];

\d .
(.tst.loadTests hsym `$) each .utl.args;
\d .tst

if[not app.runPerformance;.tst.app.specs[;`expectations]: {x .[;();_;]/ where x[;`type] = `perf} each app.specs[;`expectations]];
if[0 <> count app.runSpecs;.tst.app.specs: app.specs where (or) over app.specs[;`title] like/: app.runSpecs];
if[0 <> count app.excludeSpecs;.tst.app.specs: app.specs where not (or) over app.specs[;`title] like/: app.excludeSpecs];
 
app.results: $[not app.describeOnly;.tst.runSpec each app.specs;app.specs]

app.passed:all `pass = app.results[;`result];
if[not app.passOnly; 
 if[not app.describeOnly;-1 "\n"];
 if[not app.passed;
  -1 raze .tst.output.spec each app.results;
  ];
 if[not app.describeOnly;
  -1 "For ", string[count app.specs], " specifications, ", string[app.expectationsRan]," expectations were run.";
  -1 string[app.expectationsPassed]," passed, ",string[app.expectationsFailed]," failed.  ",string[app.expectationsErrored]," errors.";
  ];
 ];

if[app.exit; exit `int$not app.passed];
