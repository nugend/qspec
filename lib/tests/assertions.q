\d .tst

asserts:()!()
asserts[`must]:{[val;message];
  .tst.assertState.assertsRun+:1;
 if[not val;.tst.assertState.failures,: enlist message];
 }

asserts[`musteq]:{[l;r]; asserts.must[l=r;"Expected ", (string l), " to be equal to ", (string r)]}
asserts[`mustmatch]:{[l;r]; asserts.must[l~r;"Expected ", (string l), " to match ", (string r)]}
asserts[`mustne]:{[l;r]; asserts.must[l<>r;"Expected ", (string l), " to not be equal to ", (string r)]}
asserts[`mustlt]:{[l;r]; asserts.must[l<r;"Expected ", (string l), " to not be less than ", (string r)]}
asserts[`mustgt]:{[l;r]; asserts.must[l>r;"Expected ", (string l), " to not be greater than ", (string r)]}
asserts[`mustlike]:{[l;r]; asserts.must[l like r;"Expected ", (string l), " to be like ", (string r)]}
asserts[`mustin]:{[l;r]; asserts.must[l in r;"Expected ", (string l), " to be in ", (string r)]}
asserts[`mustwithin]:{[v;low;hi]; asserts.must[v within (l;h);"Expected ", (string l), " to be within ", (string r)]}
asserts[`mustdelta]:{[l;r;tol]; asserts.must[l within (r - abs tol;r + abs tolh);"Expected ", (string l), " to be within ", (string tol), " of ", (string r)]}
