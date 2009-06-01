\d .tst

asserts:()!()
asserts[`must]:{[val;message];
  .tst.assertState.assertsRun+:1;
 if[not all val;.tst.assertState.failures,: enlist message];
 }

asserts[`musteq]:{[l;r]; asserts.must[l=r;"Expected ", (-3!l), " to be equal to ", (-3!r)]}
asserts[`mustmatch]:{[l;r]; asserts.must[l~r;"Expected ", (-3!l), " to match ", (-3!r)]}
asserts[`mustnmatch]:{[l;r]; asserts.must[not l~r;"Expected ", (-3!l), " to not match ", (-3!r)]}
asserts[`mustne]:{[l;r]; asserts.must[l<>r;"Expected ", (-3!l), " to not be equal to ", (-3!r)]}
asserts[`mustlt]:{[l;r]; asserts.must[l<r;"Expected ", (-3!l), " to be less than ", (-3!r)]}
asserts[`mustgt]:{[l;r]; asserts.must[l>r;"Expected ", (-3!l), " to be greater than ", (-3!r)]}
asserts[`mustlike]:{[l;r]; asserts.must[l like r;"Expected ", (-3!l), " to be like ", (-3!r)]}
asserts[`mustin]:{[l;r]; asserts.must[l in r;"Expected ", (-3!l), " to be in ", (-3!r)]}
asserts[`mustnin]:{[l;r]; asserts.must[not l in r;"Expected ", (-3!l), " to not be in ", (-3!r)]}
asserts[`mustwithin]:{[l;r]; asserts.must[l within r;"Expected ", (-3!l), " to be within ", (-3!r)]}
asserts[`mustdelta]:{[tol;l;r]; asserts.must[l within (r - abs tol;r + abs tol);"Expected ", (-3!l), " to be within +/-", (-3!tol), " of ", (-3!r)]}
asserts[`mustthrow]:{[e;c]; 
 r:@[{x[];""};c;(::)];
 m:"Expected '", (-3!c), "' to throw ",$[not count e;
 "an error.";
 10h = type e;
 [e: enlist e;
  "the error '",(first e),"'."];
 "one of the errors ", ("," sv {"'",x,"'"} each e), "."];
 p:1b;
 if[(not count r);m,:" No error thrown";p:0b];
 if[(count e) and not any r ~/:e;m,: " Error thrown: '",r,"'";p:0b];
 asserts.must[p;m]
 }

asserts[`mustnotthrow]:{[e;c];
 r:@[{x[];""};c;(::)];
 m:"Expected '", (-3!c), "' to not throw ";
 if[10h = type e;e:enlist e];
 p:1b;
 if[(count r) and not count e;m,:"an error. Error thrown: '",r,"'";p:0b];
 if[any r ~/:e;m,: "the error '",r,"'";p:0b];
 asserts.must[p;m]
 }
