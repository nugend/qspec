.tst.desc["Loading File Fixtures"]{
 before{fixture[`myFixture]};
 should["load the fixture specified"]{
  mustnotthrow[()] {
   myFixture;
   };
  };
 should["set the fixture to the contents of the file"]{
  1 2 3 4 mustmatch myFixture;
  };
 should["load a fixture with a different name if required"]{
  fixtureAs[`myFixture;`someVariable];
  mustnotthrow[()] {
   someVariable;
   };
  myFixture mustmatch someVariable;
  };
 };
