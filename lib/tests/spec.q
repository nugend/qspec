\d .tst

runSpec:{
 x:@[x;`expectations;runExpec each];
 x[`result]:$[all `pass = x[`expectations;;`result];`pass;`fail];
 x
 }
