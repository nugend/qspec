\d .tst
uiSet:{.[`.tst;(),x;:;y]}

assertList:enlist ()!() / Asserts are built up into this variable
currentBefore:{}
currentAfter:{}

before:{[code];
 uiSet[`currentBefore;code]
 }

after:{[code];
 uiSet[`currentAfter;code]
 }

alt:{[code];                / Alt blocks allow different before/after behavior to be defined
 oldBefore: currentBefore;
 oldAfter: currentAfter;
 code[];
 `currentBefore`currentAfter uiSet' (oldBefore;oldAfter);
 }

should:{[des;code];
 assertList,: enlist .tst.internals.testObj, (`desc`code`before`after!(des;code;currentBefore;currentAfter))
 }

holds:{[des;props;code];
 assertList,: enlist .tst.internals.fuzzObj, (`desc`code`before`after!(des;code;currentBefore;currentAfter)), props
 }

perf:{[des;props;code];
 assertList,: enlist .tst.internals.perfObj, (`desc`code`before`after!(des;code;currentBefore;currentAfter)), props
 }

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
 
.tst.desc:{[title;asserts];
 oldBefore: currentBefore;
 oldAfter: currentAfter;
 oldAssertList: assertList;
 specObj: .tst.internals.specObj;
 specObj[`title]:title;
 / set up the UI for the assertion call
 / mock isn't exactly the right name for this usage.  Think of it more like "substitute"
 ((` sv `.,) each uiNames) .tst.mock' uiCode;
 ((` sv `.q,) each key asserts) .tst.mock' value asserts; / See Note on Global References
 (value string assertions)[];                             / See Note on Global References
 specObj[`assertions]:1 _ assertList;
 / Reset environment
 `assertList`currentBefore`currentAfter uiSet' (oldAssertList;oldBefore;oldAfter);
 .tst.restore[];
 specObj
 }

