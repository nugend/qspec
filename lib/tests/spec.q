\d .tst

.tst.context:`.
runSpec:{
 oldContext: .tst.context;
 .tst.context: x[`context];
 .tst.tstPath: x[`tstPath];
 x:@[x;`expectations;runExpec each];
 .tst.restoreDir[];
 .tst.context: oldContext;
 .tst.tstPath: `;
 x[`result]:$[all `pass = x[`expectations;;`result];`pass;`fail];
 x
 }
