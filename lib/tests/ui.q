\d .tst
uiSet:{.[`.tst;(),x;:;y]}

resetExpecList:{uiSet[`expecList;enlist ()!()]} / Asserts are built up into this variable
resetExpecList[];
currentBefore:{}
currentAfter:{}

before:{[code];
 uiSet[`currentBefore;code]
 }

after:{[code];
 uiSet[`currentAfter;code]
 }

// Before and After values can be set after the expectation (under the specification)
fillExpecBA:{
  x:@[x;1 _ where {not `before in key x} each x;{x,enlist[`before]!enlist currentBefore}];
  1 _ @[x;1 _ where {not `after in key x} each x;{x,enlist[`after]!enlist currentAfter}]
  }

alt:{[code];                / Alt blocks allow different before/after behavior to be defined
 oldBefore: currentBefore;
 oldAfter: currentAfter;
 oldExpecList: expecList;
 resetExpecList[];
 code[];
 el:fillExpecBA expecList;
 / Reset environment
 `expecList`currentBefore`currentAfter uiSet' (oldExpecList;oldBefore;oldAfter);
 expecList,:el;
 }

should:{[des;code];
 expecList,: enlist .tst.internals.testObj, (`desc`code!(des;code))
 }

holds:{[des;props;code];
 expecList,: enlist .tst.internals.fuzzObj, (`desc`code!(des;code)), props
 }

perf:{[des;props;code];
 expecList,: enlist .tst.internals.perfObj, (`desc`code!(des;code)), props
 }

uiRuntimeNames:`fixture`fixtureAs`mock
uiRuntimeCode: (.tst.fixture;.tst.fixtureAs;.tst.mock)
uiNames:`before`after`should`holds`perf`alt
uiCode:(before;after;should;holds;perf;alt)

/ Note on Global References:
/ Because of the way Q handles global references, we cannot use the code object of the expectations parameter
/ Instead We take the value string of the object and re-evaluate it to execute a new code object with the 
/ .q assertions functions in place.  (You may see this by taking an expectation function definition and 
/ examining the list of globals "(value expectations) 3" without a custom .q function defined and with one
/ defined. E.g:
/ (value {2 musteq 2}) 3
/ .q.musteq: {x+y}
/ (value {2 musteq 2}) 3
 
.tst.desc:{[title;expectations];
 oldBefore: currentBefore;
 oldAfter: currentAfter;
 oldExpecList: expecList;
 resetExpecList[];
 specObj: .tst.internals.specObj;
 specObj[`title]:title;
 / set up the UI for the expectation call
 / mock isn't exactly the right name for this usage.  Think of it more like "substitute"
 ((` sv `.q,) each uiRuntimeNames,uiNames,key asserts) .tst.mock' uiRuntimeCode,uiCode,value asserts; / See Note on Global References
 (value string expectations)[];                           / See Note on Global References
 specObj[`context]: system "d";
 specObj[`tstPath]: .utl.FILELOADING;
 specObj[`expectations]:fillExpecBA expecList;
 / Reset environment
 `expecList`currentBefore`currentAfter uiSet' (oldExpecList;oldBefore;oldAfter);
 .tst.restore[];
 .tst.callbacks.descLoaded specObj;
 specObj
 }

