\d .tst
uiSet:{.[`.tst;(),x;:;y]}

/TODO: Something's definitely not right with this for accumulating desc-y dicts
oldAssertList:assertList:enlist ()!() / Asserts are built up into this variable
currentBefore:{}
currentAfter:{}

before:{[code];
 uiSet[`currentBefore;code]
 }

after:{[code];
 uiSet[`currentAfter;code]
 }

alt:{[code];
 oldBefore: currentBefore;
 oldAfter: currentAfter;
 code[];
 uiSet[`currentBefore;oldBefore];
 uiSet[`currentAfter;oldAfter]
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
 specObj: .tst.internals.specObj;
 specObj[`title]:title;
 / set up the UI for the assertion call
 ((` sv `.,) each uiNames) .tst.mock' uiCode;
 asserts[];
 specObj[`assertions]:1 _ assertList;
 / Reset environment
 uiSet[`assertList;oldAssertList];
 .tst.restore[];
 specObj
 }

