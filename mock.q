\d .tst
initStore:store:(enlist `)!enlist (::)
removeList:()

/ Used to replace the variable specified by name with newVal.  Existing values will be clobbered
/ until restored.  Standard variable re-assignment caveats apply
/ CAUTION: Mocking out the mock module is inadvisable
mock:{[name;newVal];
 name:$[1 = c: count ` vs name;
  / Create fully qualified name if given a local one
  ` sv (system "d"),name;
  (2 = c) and ` ~ first ` vs name;
  '"Can't mock top-level namespaces!";
  name];
 / Early abort if name will be removed later
 if[name in removeList; :name set newVal];
 if[`dne ~ @[get;name;`dne]; removeList,:name; :name set newVal];
 if[not name in key store; store[name]:get name];
 name set newVal
 }

/ Restores the environment to the previous state before any .mock.mock calls were made
restore:{
 / Restore all fully qualified symbols
 (set') . (key;value) @\: 1 _ store;
 `store set initStore;
 / Drop each fully qualified symbol from its respective namespace
 (.[;();_;]') . flip ((` sv -1 _;last) @\: ` vs) each removeList;
 `removeList set ();
 }
