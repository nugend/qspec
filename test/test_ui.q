.tst.desc["The Testing UI"]{
 alt {
  before{
   `myRestore mock .tst.restore;
   `.tst.restore mock {};
   `.tst.callbacks.loadDesc mock {};
   `.tst.mock mock {[x;y]};
  };
  after{
   myRestore[];
   };
  should["let you create specifications"]{
   descStr: "This is a description";
   myDesc: .tst.desc[descStr]{}; / Not testing the other parts of the UI here
   99h musteq type myDesc;
   descStr musteq myDesc`title;
   };
  should["cause specifications to assume the context that they were defined in"]{
   oldContext: string system "d";
   system "d .foo";
   myDesc: .tst.desc["Blah"]{};
   system "d ", oldContext;
   `.foo musteq myDesc`context;
   };
  should["call the loadDesc callback when a new specification is defined"]{
   `callbackCalled mock 0b;
   `.tst.callbacks.loadDesc mock {`callbackCalled set 1b};
   .tst.desc["Blah"]{};
   must[callbackCalled;"Expected for the loadDesc callback to be called"];
   };
  };
 should["let you set a before function"]{
  `.tst.currentBefore mock .tst.currentBefore;
  bFunction: {"unique message"};
  .tst.before bFunction;
  bFunction mustmatch .tst.currentBefore;
  };
 should["let you set an after function"]{
  `curentAfter mock .tst.currentAfter;
  aFunction: {"unique message"};
  .tst.after aFunction;
  aFunction mustmatch .tst.currentAfter;
  };
 should["let you create an expectation"]{
  `.tst.expecList mock .tst.expecList;
  description:"unique description";
  func:{"unique message"};
  .tst.should[description;func];
  1 musteq count 1 _ .tst.expecList;
  description musteq first (1 _ .tst.expecList)[`desc];
  func mustmatch first (1 _ .tst.expecList)[`code];
  };
 should["let you create a fuzz expectation"]{
  `.tst.expecList mock .tst.expecList;
  description:"unique description";
  func:{"unique message"};
  .tst.holds[description;()!();func];
  1 musteq count 1 _ .tst.expecList;
  description musteq first (1 _ .tst.expecList)[`desc];
  func mustmatch first (1 _ .tst.expecList)[`code];
  };
 should["let you mask before and after functions inside of alternate blocks"]{
  `.tst.currentBefore`.tst.currentAfter mock' .tst[`currentBefore`currentAfter];
  .tst.before {"unique before"};
  .tst.after {"unique after"};
  .tst.alt {
   .tst.before {"another before"};
   .tst.after {"another after"};
   {"another before"} mustmatch .tst.currentBefore;
   {"another after"} mustmatch .tst.currentAfter;
   };
  {"unique before"} mustmatch .tst.currentBefore;
  {"unique after"} mustmatch .tst.currentAfter;
  };
 };
