.tst.desc["Running a specification should"]{
 before{
  `defaultSpecification mock `context`tstPath`expectations!(`.foo;`:/foo/bar;enlist (`result,())!(),`pass);
  `.tst.runExpec mock {[x;y]y};
  };
 should["set the correct context and the correct filepath for its expectations"]{
  `.tst.runExpec mock {[x;y];
   .tst.context mustmatch `.foo;
   .tst.tstPath mustmatch `:/foo/bar;
   x
   };
  .tst.runSpec defaultSpecification;
  };
 should["restore any partitioned directories that were loaded"]{
  `..run mock 0b;
  `.tst.restoreDir mock {`..run mock 1b}; / This won't be executed in the same context
  .tst.runSpec defaultSpecification;
  must[`.[`run];"Expected the directory restoring function to have been called"];
  };
 should["restore the context and filepath to what they previously were"]{
  oldContext: .tst.context;
  oldPath: .tst.tstPath;
  .tst.runSpec defaultSpecification;
  oldContext mustmatch .tst.context;
  oldPath mustmatch .tst.tstPath;
  };
 should["pass only if all expectations passed"]{
  run1: .tst.runSpec defaultSpecification;
  run1[`result] mustmatch `pass;
  otherSpecification: defaultSpecification;
  otherSpecification[`expectations]: ((`result,())!(),`fail;(`result,())!(),`pass);
  run2: .tst.runSpec otherSpecification;
  run2[`result] mustmatch `fail;
  };
 should["work with an empty expectation list"]{
  mustnotthrow[();{.tst.runSpec @[defaultSpecification;`expectations;:;([];result:`symbol$())]}];
  mustnotthrow[();{.tst.runSpec @[defaultSpecification;`expectations;:;()]}];
  };
 };

.tst.desc["Halting execution of specifications"]{
 before{
  `defaultSpecification mock `context`tstPath`expectations!(`.foo;`:/foo/bar;enlist (`result,())!(),`pass);
  `.tst.runExpec mock {[x;y]y};
  `myOldContext mock .tst.context;
  `myOldPath mock .tst.tstPath;
  `.tst.halt mock 1b;
  };
 after{
  .tst.halt:0b;
  .tst.restoreDir[];
  .tst.context:myOldContext;
  .tst.tstPath:myOldPath;
  };
 should["not run further expectations"]{
  `.tst.runExpec mock {[x;y]'"error"};
  mustnotthrow[();{.tst.runSpec defaultSpecification}];
  };
 should["not restore the context and filepath to what they previously were"]{
  .tst.runSpec defaultSpecification;
  myOldContext mustnmatch .tst.context;
  myOldPath mustnmatch .tst.tstPath;
  };
 };
