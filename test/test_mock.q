.tst.desc["Mocking"]{
 should["assign the given value to the named variable"]{
  `foo mock 0;
  foo musteq 0;
  };
 should["assign to a non-fully qualifeid name with respect to the current context"]{
  `.tst.context mock `.foo;
  `foo mock 3;
  .foo.foo musteq 3;
  };
 should["backup a variable if it already exists"]{
  `..foo set 0;
  `..foo mock 1;
  .tst.restore[];
  (get `..foo) musteq 0;
  delete foo from `.;
  };
 should["remove any variables that did not originally exist when all variables are restored"]{
  `foo mock 1;
  .tst.restore[];
  mustthrow["foo"] {get `foo};
  };
 should["refuse to mock a top level namespace"]{
  mustthrow[()] { `.tst mock ` };
  };
 };
