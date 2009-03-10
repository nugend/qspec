\d .tst

.tst.context:`.
runSpec:{
 oldContext: .tst.context;
 .tst.context: x[`context];
 x:@[x;`expectations;runExpec each];
 .tst.context: oldContext;
 x[`result]:$[all `pass = x[`expectations;;`result];`pass;`fail];
 x
 }
