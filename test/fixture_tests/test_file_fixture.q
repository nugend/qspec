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
 alt{
  before{fixture `splayFixture};
  should["load a splayed directory as a file fixture"]{
   ([]a:1 2 3;b:4 5 6) mustmatch splayFixture;
   };
  };
 };
