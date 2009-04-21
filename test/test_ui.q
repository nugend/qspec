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
 };
