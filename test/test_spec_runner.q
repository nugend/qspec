.tst.desc["Running a specification should"]{
 before{
  `.tst.runExpec mock {x};
  `defaultSpecification mock `context`tstPath`expectations!(`.foo;`:/foo/bar;enlist (`result,())!(),`pass)
  };
 should["set the correct context and the correct filepath for its expectations"]{
  `.tst.runExpec mock {
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
