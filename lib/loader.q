\d .tst

loadTests:{[paths]; .utl.require each findTests[paths]}

findTests:{[paths];
 distinct raze suffixMatch[".q"] each distinct (),paths
 }

suffixMatch:{[suffix;path];
 if[path like "*",suffix;:enlist path];
 f: ` sv' path,'f where not (f:(),key path) like ".*";
 d: f where 11h = (type key@) each f;
 f: f where f like "*",suffix;
 raze f, .z.s[suffix] each d
 }

testFilePath:{` sv (` vs .tst.tstPath)[0],x}
