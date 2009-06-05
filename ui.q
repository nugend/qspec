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
 assertList,: enlist .tst.internals.expecObj, (`desc`code`before`after!(des;code;currentBefore;currentAfter))
 }

holds:{[des;props;code];
 assertList,: enlist .tst.internals.fuzzObj, (`desc`code`before`after!(des;code;currentBefore;currentAfter)), props
 }

perf:{[des;props;code];
 assertList,: enlist .tst.internals.perfObj, (`desc`code`before`after!(des;code;currentBefore;currentAfter)), props
 }

uiNames:`before`after`should`holds`perf`alt`mock
uiCode:(before;after;should;holds;perf;alt;.tst.mock)

.tst.desc:{[title;asserts];
 oldBefore: currentBefore;
 oldAfter: currentAfter;
 oldAssertList: assertList;
 specObj: .tst.internals.specObj;
 specObj[`title]:title;
 / set up the UI for the assertion call
 / mock isn't exactly the right name for this usage.  Think of it more like "substitute"
 ((` sv `.,) each uiNames) .tst.mock' uiCode;
 asserts[];
 specObj[`assertions]:1 _ assertList;
 / Reset environment
 `assertList`currentBefore`currentAfter uiSet' (oldAssertList;oldBefore;oldAfter);
 .tst.restore[];
 specObj
 }

