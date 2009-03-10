\d .tst

asserts:()!()
asserts[`must]:{[val;message];
  .tst.assertState.assertsRun+:1;
 if[not all val;.tst.assertState.failures,: enlist message];
 }

asserts[`musteq]:{[l;r]; asserts.must[l=r;"Expected ", (-3!l), " to be equal to ", (-3!r)]}
asserts[`mustmatch]:{[l;r]; asserts.must[l~r;"Expected ", (-3!l), " to match ", (-3!r)]}
asserts[`mustne]:{[l;r]; asserts.must[l<>r;"Expected ", (-3!l), " to not be equal to ", (-3!r)]}
asserts[`mustlt]:{[l;r]; asserts.must[l<r;"Expected ", (-3!l), " to not be less than ", (-3!r)]}
asserts[`mustgt]:{[l;r]; asserts.must[l>r;"Expected ", (-3!l), " to not be greater than ", (-3!r)]}
asserts[`mustlike]:{[l;r]; asserts.must[l like r;"Expected ", (-3!l), " to be like ", (-3!r)]}
asserts[`mustin]:{[l;r]; asserts.must[l in r;"Expected ", (-3!l), " to be in ", (-3!r)]}
asserts[`mustwithin]:{[v;low;hi]; asserts.must[v within (l;h);"Expected ", (-3!l), " to be within ", (-3!r)]}
asserts[`mustdelta]:{[l;r;tol]; asserts.must[l within (r - abs tol;r + abs tolh);"Expected ", (-3!l), " to be within ", (-3!tol), " of ", (-3!r)]}
